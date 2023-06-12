///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		ТекстСообщения = НСтр("ru = 'Запрещено уничтожать персональные данные в подчиненном узле.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
		Метаданные.Документы.АктОбУничтоженииПерсональныхДанных);
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ПодменюПечать;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьПараметрыСпискаСроковХранения();
	
	ОбновитьСрокиХранения = РегистрыСведений.СубъектыДляРасчетаСроковХранения.ЕстьСубъектыДляРасчетаСроковХранения();
		
	УстановитьВидимостьЭлементов();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбновитьСрокиХранения Тогда
		
		ДлительнаяОперация = ОбновитьСрокиХранения();
		
		Оповещение = Новый ОписаниеОповещения("ПриПроверкеРасчетаСроковХранения", ЭтотОбъект);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьТолькоПросроченныеПриИзменении(Элемент)
	
	УстановитьПараметрыСпискаСроковХранения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСрокиХранения

&НаКлиенте
Процедура СрокиХраненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Элементы.СрокиХранения.ТекущиеДанные.Субъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАкты(Команда)

	СубъектыИОрганизации = Новый Массив; // Массив из ОпределяемыйТип.СубъектПерсональныхДанных
	Для каждого СтрСписка Из Элементы.СрокиХранения.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СрокиХранения.ДанныеСтроки(СтрСписка);
		СубъектыИОрганизации.Добавить(
			Новый Структура("Субъект,Организация", ДанныеСтроки.Субъект, ДанныеСтроки.Организация));
	КонецЦикла;
	
	Если СубъектыИОрганизации.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Для создания актов выделите строки в списке'"));
		Возврат;
	КонецЕсли;

	СписокСубъектов = Новый СписокЗначений();
	СписокСубъектов.ЗагрузитьЗначения(СубъектыИОрганизации);
	
	Оповещение = Новый ОписаниеОповещения("ФормаСозданияАктовПослеЗакрытия", ЭтотОбъект, СубъектыИОрганизации);
	
	ОткрытьФорму("Обработка.УничтожениеПерсональныхДанных.Форма.ФормаСозданияАктов",
		Новый Структура("СубъектыИОрганизации", СписокСубъектов), ЭтотОбъект, , , , Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаРасчетСроковХранения", "Видимость",
		ОбновитьСрокиХранения);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КнопкаСоздатьАкты", "Доступность",
		Не ОбновитьСрокиХранения);
		
	Если РегистрыСведений.СрокиХраненияПерсональныхДанных.ЕстьРассчитанныеСрокиХранения() Тогда
		Элементы.СтраницыГруппа.ТекущаяСтраница = Элементы.УничтожениеДанныхСтраница;
		Если Документы.АктОбУничтоженииПерсональныхДанных.ЕстьАкты() Тогда
			Элементы.АктыОбУничтоженииСтраницы.ТекущаяСтраница = Элементы.АктыОбУничтоженииСтраница;
		Иначе
			Элементы.АктыОбУничтоженииСтраницы.ТекущаяСтраница = Элементы.АктыОбУничтоженииПустаяСтраница;
		КонецЕсли;
	Иначе
		Элементы.СтраницыГруппа.ТекущаяСтраница = Элементы.ПустаяСтраница;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "АктыОбУничтожении.Дата",
		Элементы.АктыОбУничтоженииДата.Имя);
		
	// Красный цвет текста если срок хранения меньше начала текущего дня.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СрокиХранения.Имя);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Элемент.Отбор, 
		"СрокиХранения.СрокХранения", НачалоДня(ТекущаяДатаСеанса()), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСпискаСроковХранения()

	ДатаБессрочно = Дата(3999, 12, 31);
	Если ПоказыватьТолькоПросроченные Тогда
		ДатаАктуальности = НачалоДня(ТекущаяДатаСеанса());
	Иначе
		ДатаАктуальности = ДатаБессрочно;
	КонецЕсли;
	
	СрокиХранения.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности", ДатаАктуальности);
	СрокиХранения.Параметры.УстановитьЗначениеПараметра("ДатаБессрочно", ДатаБессрочно);

КонецПроцедуры

// Форма создания актов после закрытия.
// 
// Параметры:
//  Результат - Строка, Структура - :
//   * Организация - ОпределяемыйТип.Организация
//   * ПричинаУничтожения - Строка
//   * СпособУничтожения - Строка
//   * ОтветственныйЗаОбработкуПерсональныхДанных - СправочникСсылка.Пользователи
//  СубъектыИОрганизации - Массив из Структура:
//   * Субъект - ОпределяемыйТип.СубъектПерсональныхДанных
//   * Организация - ОпределяемыйТип.Организация
&НаКлиенте
Процедура ФормаСозданияАктовПослеЗакрытия(Результат, СубъектыИОрганизации) Экспорт

	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = РезультатСозданияАктов(СубъектыИОрганизации, Результат);
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		Для Каждого Сообщение Из ДлительнаяОперация.Сообщения Цикл
			Сообщение.Сообщить();
		КонецЦикла;
		ПриЗавершенииСозданияАктов(ДлительнаяОперация);
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Формируются акты об уничтожении персональных данных'");
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ВыводитьСообщения = Истина;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	
	Оповещение = Новый ОписаниеОповещения("ПриЗавершенииСозданияАктов", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры

// Параметры:
//  СубъектыИОрганизации - Массив из Структура:
//   * Субъект - ОпределяемыйТип.СубъектПерсональныхДанных
//   * Организация - ОпределяемыйТип.Организация
//  ДанныеЗаполнения - см. ФормаСозданияАктовПослеЗакрытия.Результат
// 
// Возвращаемое значение:
//   см. ДлительныеОперации.ВыполнитьПроцедуру
&НаСервере
Функция РезультатСозданияАктов(СубъектыИОрганизации, ДанныеЗаполнения)
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	
	Возврат ДлительныеОперации.ВыполнитьПроцедуру(ПараметрыВыполнения,
		"Обработки.УничтожениеПерсональныхДанных.СоздатьАкты", СубъектыИОрганизации, ДанныеЗаполнения);
	
КонецФункции

&НаКлиенте
Процедура ПриЗавершенииСозданияАктов(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
	Типы = Новый Массив; // Массив из Тип
	Типы.Добавить(Тип("ДокументСсылка.АктОбУничтоженииПерсональныхДанных"));
	Типы.Добавить(Тип("РегистрСведенийКлючЗаписи.СрокиХраненияПерсональныхДанных"));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Типы, ЗащитаПерсональныхДанныхВызовСервера.ТипыСубъектов());
	
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъектов(Новый ОписаниеТипов(Типы));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Функция ОбновитьСрокиХранения()
	
	Возврат ЗащитаПерсональныхДанных.ОбновитьСрокиХраненияПерсональныхДанныхВФоне(УникальныйИдентификатор);
		
КонецФункции

&НаКлиенте
Процедура ПриПроверкеРасчетаСроковХранения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьСрокиХранения = Ложь;
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.СрокиХраненияПерсональныхДанных"));
	УстановитьВидимостьЭлементов();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.АктыОбУничтожении);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.АктыОбУничтожении);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.АктыОбУничтожении);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
