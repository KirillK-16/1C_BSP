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

	СостоянияОригиналов = УчетОригиналовПервичныхДокументов.ИспользуемыеСостояния();
	УчетОригиналовПервичныхДокументов.ВывестиНаФормуКомандыСостоянияОригинала(ЭтотОбъект, КомплектПечатныхФорм, СостоянияОригиналов);
		
	ЗаполнитьСписокПечатныхФормПоСсылке();

	Если Параметры.Свойство("ДокументСсылка") Тогда
		Запись.Владелец = Параметры.ДокументСсылка;
		ФильтрПечатныхФорм = "Все";
		Элементы.НадписьПредупреждение.Заголовок = НСтр("ru='Состояние оригинала документа будет установлено по печатным формам'");
	ИначеЕсли КомплектПечатныхФорм.Количество()= 0 Тогда
		ЗаполнитьВсеПечатныеФормы();
		ФильтрПечатныхФорм = "Все";
		Элементы.НадписьПредупреждение.Заголовок = НСтр("ru='Состояние оригинала документа будет установлено по печатным формам'");
	Иначе
		ФильтрПечатныхФорм = "Отслеживаемые";
	КонецЕсли;	

	УстановитьСсылкуНаОригинал();

	Если КомплектПечатныхФорм.Количество()= 0 Тогда
		ВосстанавливатьФильтр = Ложь;
	Иначе
		ВосстанавливатьФильтр = Истина;
	КонецЕсли;
		
	ВосстановитьНастройки(ВосстанавливатьФильтр);

	УстановитьСсылкуНаОригинал();
	
	УстановитьФильтрПечатныхФорм();
	
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КомплектПечатныхФорм.Состояние"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	ЭлементОтбора.Использование = Истина;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  WebЦвета.СеребристоСерый);
	ЭлементОформления.Использование = Истина;

	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("КомплектПечатныхФормПредставление");
	ПолеОформления.Использование = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	Если ИмяСобытия = "ДобавлениеУдалениеСостоянияОригиналаПервичногоДокумента" Тогда
		Подключаемый_ОбновитьКомандыСостоянияОригинала();
		ОбновитьОтображениеДанных();
	ИначеЕсли ИмяСобытия = "ИзменениеСостоянияОригиналаПервичногоДокумента" 
		Или ИмяСобытия = "ТабличныеДокументыНапечатаны" Тогда
		
		КомплектПечатныхФорм.Очистить();
		ПоказатьОтслеживаемыеНаСервере();
		Если КомплектПечатныхФорм.Количество()=0 Тогда
			 ПоказатьВсеНаСервере();
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СсылкаНаДокументНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Запись.Владелец);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура КомплектПечатныхФормВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ОригиналПолученКартинка" Тогда
		УстановитьСостояниеОригинала("УстановитьОригиналПолучен");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормСостояниеПриИзменении(Элемент)

	КоличествоСдвинуть = 0;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			КоличествоСдвинуть = КоличествоСдвинуть+1;
		КонецЕсли;
	КонецЦикла;

	ТекущаяСтрока = Элементы.КомплектПечатныхФорм.ТекущиеДанные;
	НовыйИндекс = КомплектПечатныхФорм.Индекс(ТекущаяСтрока);

	Если Не НовыйИндекс <= КоличествоСдвинуть Тогда
		КоличествоСдвинуть = НовыйИндекс - КоличествоСдвинуть +1;
		КомплектПечатныхФорм.Сдвинуть(НовыйИндекс,-КоличествоСдвинуть);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Элементы.КомплектПечатныхФорм.ТекущиеДанные.Состояние) Тогда
		Элементы.КомплектПечатныхФорм.ТекущиеДанные.ОригиналПолученКартинка = 0;
	КонецЕсли;

	Элементы.КомплектПечатныхФорм.ТекущиеДанные.АвторИзменения = ПользователиКлиент.ТекущийПользователь();
	Элементы.КомплектПечатныхФорм.ТекущиеДанные.ДатаПоследнегоИзменения = НСтр("ru = '<только что>'");
	
КонецПроцедуры

&НаКлиенте
Процедура КомплектПечатныхФормСостояниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен") Тогда
		Элементы.КомплектПечатныхФорм.ТекущиеДанные.ОригиналПолученКартинка = 1;
	Иначе
		Элементы.КомплектПечатныхФорм.ТекущиеДанные.ОригиналПолученКартинка = 0;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОчиститьНеОтслеживаемые();

	УстановитьОбщееСостояние();
	
	СохранитьНастройки();
	
	Если КомплектПечатныхФорм.Количество()<> 0  Тогда
		ЗаписатьСостоянияОригиналовПервичныхДокументов();
		Оповестить("ИзменениеСостоянияОригиналаПервичногоДокумента");
		Закрыть();
		УчетОригиналовПервичныхДокументовКлиент.ОповеститьПользователяОбУстановкеСостояний(1, Запись.Владелец);
	ИначеЕсли КомплектПечатныхФорм.Количество() = 0 Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  Команда - КомандаФормы
//
//@skip-warning
//
&НаКлиенте
Процедура Подключаемый_УстановитьСостояниеОригинала(Команда)

	Если Команда.Имя = "НастройкаСостояний" Тогда
		УчетОригиналовПервичныхДокументовКлиент.ОткрытьФормуНастройкиСостояний();
	Иначе
		УстановитьСостояниеОригинала(Команда.Имя);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()

	УчетОригиналовПервичныхДокументов.ОбновитьКомандыСостоянияОригинала(ЭтотОбъект,Элементы.КомплектПечатныхФорм);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСостояниеОригинала(Команда)

	НайденноеСостояние = Элементы.Найти(Команда);

	Если Не НайденноеСостояние = Неопределено Тогда
		ИмяСостояния = НайденноеСостояние.Заголовок;
	ИначеЕсли Команда = "УстановитьОригиналПолучен" Тогда
		ИмяСостояния = "Оригинал получен";
	Иначе 
		Возврат;
	КонецЕсли;

	Для Каждого СтрокаСписка Из Элементы.КомплектПечатныхФорм.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.КомплектПечатныхФорм.ДанныеСтроки(СтрокаСписка);

		ДанныеСтроки.Состояние = НайтиСостояниеВСправочнике(ИмяСостояния);
		
		Если ДанныеСтроки.Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен") Тогда
			ДанныеСтроки.ОригиналПолученКартинка = 1;
		Иначе
			ДанныеСтроки.ОригиналПолученКартинка = 0;
		КонецЕсли;

		ДанныеСтроки.Состояние = НайтиСостояниеВСправочнике(ИмяСостояния);
	КонецЦикла;

	Элементы.КомплектПечатныхФорм.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВсе(Команда)

	ПоказатьВсеНаСервере() 

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтслеживаемые(Команда)
	
	ПоказатьОтслеживаемыеНаСервере()
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВручную(Команда)

	Если Не ЗначениеЗаполнено(ПечатнаяФормаВручную) Тогда
		Возврат;
	КонецЕсли;

	ПервичныйДокумент = СтрЗаменить(ПечатнаяФормаВручную," ","");
	
	НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Новый Структура("ИмяМакета",ПервичныйДокумент));

	Если НайденныеСтроки.Количество() > 0 Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'В списке уже есть такая форма.'"));
		Возврат;
	КонецЕсли;

	Элементы.ДобавитьСвою.Скрыть();
	КоличествоСдвинуть = 0;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			КоличествоСдвинуть = КоличествоСдвинуть+1;
		КонецЕсли;
	КонецЦикла;

	Если КоличествоСдвинуть = 0 Тогда
		КоличествоСдвинуть = КомплектПечатныхФорм.Количество();
	Иначе
		КоличествоСдвинуть = КомплектПечатныхФорм.Количество() - КоличествоСдвинуть;
	КонецЕсли;

	НоваяСтрока = КомплектПечатныхФорм.Добавить();
	НоваяСтрока.ИмяМакета = ПервичныйДокумент;
	НоваяСтрока.Представление = ПечатнаяФормаВручную;
	НоваяСтрока.Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ФормаНапечатана");
	НоваяСтрока.Извне = Истина;
	НоваяСтрока.Картинка = 2;
	НоваяСтрока.ОригиналПолученКартинка = 0;

	ПоследняяСтрока = КомплектПечатныхФорм.Количество()-1;

	КомплектПечатныхФорм.Сдвинуть(ПоследняяСтрока,-КоличествоСдвинуть);

	Элементы.КомплектПечатныхФорм.Обновить();
	Элементы.КомплектПечатныхФорм.ВыделенныеСтроки.Очистить();
	Элементы.КомплектПечатныхФорм.ВыделенныеСтроки.Добавить(НоваяСтрока.ПолучитьИдентификатор());

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеТаблицыКомплектПечатныхФорм

&НаСервере
Процедура ЗаполнитьПервоначальныйСписокПечатныхФорм()

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		МодульУправлениеПечатью = ОбщегоНазначения.ОбщийМодуль("УправлениеПечатью");
	Иначе
		Возврат;
	КонецЕсли;
		
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Владелец));
	СписокОбъектов = Новый Массив;
	СписокОбъектов.Добавить(ОбъектМетаданных);

	КоллекцияПечатныхФорм = МодульУправлениеПечатью.КомандыПечатиОбъектаДоступныеДляВложений(ОбъектМетаданных);
	СписокПечатныхФорм = Новый СписокЗначений;
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм Цикл
		СписокПечатныхФорм.Добавить(ПечатнаяФорма.Идентификатор, ПечатнаяФорма.Представление);
	КонецЦикла;
	ОбъектыПечати = Новый СписокЗначений;
	ОбъектыПечати.Добавить(Запись.Владелец);
	УчетОригиналовПервичныхДокументов.ПриОпределенииСпискаПечатныхФорм(ОбъектыПечати, СписокПечатныхФорм);
	
	ОбъектМетаданных = ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Владелец);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
		МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
		ЗапросТаблицаКоманд = МодульДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(
			Перечисления["ВидыДополнительныхОтчетовИОбработок"].ПечатнаяФорма,ОбъектМетаданных, Истина);
		ТаблицаКоманд = ЗапросТаблицаКоманд.Выполнить().Выгрузить();
	КонецЕсли;
	
	ТабличнаяЧасть = УчетОригиналовПервичныхДокументов.ТабличнаяЧастьМногосотрудниковаДокумента(Запись.Владелец); 
	Если ТабличнаяЧасть <> "" Тогда
		
		МодульФизическиеЛицаКлиентСервер = Неопределено; // Инициализация переменной для международной версии
		
		Для Каждого Сотрудник Из Запись.Владелец[ТабличнаяЧасть] Цикл
			СотрудникИзТЧ = Сотрудник.Сотрудник;  // СправочникСсылка - 
			ФИО = СотрудникИзТЧ.Наименование;
			// Локализация
			МодульФизическиеЛицаКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ФизическиеЛицаКлиентСервер");
			Если МодульФизическиеЛицаКлиентСервер <> Неопределено Тогда
				ФИО = МодульФизическиеЛицаКлиентСервер.ФамилияИнициалы(СотрудникИзТЧ.Наименование);
			Иначе
				ФИО = СотрудникИзТЧ.Наименование;
			КонецЕсли;
			// Конец Локализация
			Для Каждого ТекСтрока Из СписокПечатныхФорм Цикл
				Значения = Новый Структура("Представление, ФИО", ТекСтрока.Представление,ФИО);
				НоваяСтрока = КомплектПечатныхФорм.Добавить();
				НоваяСтрока.ИмяМакета = ТекСтрока.Значение;
				НоваяСтрока.Представление = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтр("ru='[Представление] [ФИО]'"), Значения);
				НоваяСтрока.Картинка = 1; 
				НоваяСтрока.ОригиналПолученКартинка = 0;
				НоваяСтрока.Сотрудник = СотрудникИзТЧ;
			КонецЦикла;
		КонецЦикла;
		Если ТаблицаКоманд.Количество() > 0 Тогда
			Для Каждого Сотрудник Из Запись.Владелец[ТабличнаяЧасть] Цикл
				Если МодульФизическиеЛицаКлиентСервер <> Неопределено Тогда
					ФИО = МодульФизическиеЛицаКлиентСервер.ФамилияИнициалы(СотрудникИзТЧ.Наименование);
				Иначе
					ФИО = СотрудникИзТЧ.Наименование;
				КонецЕсли;
				Для Каждого ТекСтрока Из ТаблицаКоманд Цикл
					Значения = Новый Структура("Представление, ФИО", ТекСтрока.Представление,ФИО);
					Если КомплектПечатныхФорм.НайтиСтроки(Новый Структура("ИмяМакета", ТекСтрока.Идентификатор)) = 0 Тогда
						НоваяСтрока = КомплектПечатныхФорм.Добавить();
						НоваяСтрока.ИмяМакета = ТекСтрока.Значение;
						НоваяСтрока.Представление =  СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтр("ru='[Представление] [ФИО]'"), Значения);
						НоваяСтрока.Картинка = 1;
						НоваяСтрока.ОригиналПолученКартинка = 0;
						НоваяСтрока.Сотрудник = СотрудникИзТЧ;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Для Каждого ТекСтрока Из СписокПечатныхФорм Цикл
			НоваяСтрока = КомплектПечатныхФорм.Добавить();
			Идентификатор = ТекСтрока.Значение;
			НоваяСтрока.ИмяМакета = Идентификатор;
			НоваяСтрока.Представление = ТекСтрока.Представление;
			НоваяСтрока.Картинка = 1; 
			НоваяСтрока.ОригиналПолученКартинка = 0;
		КонецЦикла;

		Если ТаблицаКоманд.Количество() > 0 Тогда
			Для Каждого ТекСтрока Из ТаблицаКоманд Цикл

				Если КомплектПечатныхФорм.НайтиСтроки(Новый Структура("ИмяМакета", ТекСтрока.Идентификатор)) = 0 Тогда
					НоваяСтрока = КомплектПечатныхФорм.Добавить();
					Идентификатор = ТекСтрока.Значение;
					НоваяСтрока.ИмяМакета = Идентификатор;
					НоваяСтрока.Представление = ТекСтрока.Представление;
					НоваяСтрока.Картинка = 1;
					НоваяСтрока.ОригиналПолученКартинка = 0;
				КонецЕсли;

			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	НенужныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Представление","Комплект документов на принтер"));
	Для Каждого НеНужнаяСтрока Из НенужныеСтроки Цикл
		КомплектПечатныхФорм.Удалить(НеНужнаяСтрока);
	КонецЦикла;

	НенужныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Новый Структура("Представление","Комплект документов с настройкой..."));
	Для Каждого НеНужнаяСтрока Из НенужныеСтроки Цикл
		КомплектПечатныхФорм.Удалить(НеНужнаяСтрока);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПечатныхФормПоСсылке()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокумент КАК ПервичныйДокумент,
	               |	СостоянияОригиналовПервичныхДокументов.Состояние КАК Состояние,
	               |	СостоянияОригиналовПервичныхДокументов.ФормаИзвне КАК Извне,
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокументПредставление КАК Представление,
	               |	СостоянияОригиналовПервичныхДокументов.ДатаПоследнегоИзменения КАК ДатаПоследнегоИзменения,
	               |	СостоянияОригиналовПервичныхДокументов.АвторИзменения КАК АвторИзменения,
	               |	СостоянияОригиналовПервичныхДокументов.Сотрудник КАК Сотрудник
	               |ИЗ
	               |	РегистрСведений.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	               |ГДЕ
	               |	НЕ СостоянияОригиналовПервичныхДокументов.ОбщееСостояние
	               |	И СостоянияОригиналовПервичныхДокументов.Владелец = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Запись.Владелец);

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		НоваяСтрока = КомплектПечатныхФорм.Добавить();
		НоваяСтрока.ИмяМакета = Выборка.ПервичныйДокумент;
		НоваяСтрока.Представление = Выборка.Представление;
		НоваяСтрока.Состояние = Выборка.Состояние;
		НоваяСтрока.Извне = Выборка.Извне;
		НоваяСтрока.ДатаПоследнегоИзменения =  Выборка.ДатаПоследнегоИзменения;
		НоваяСтрока.АвторИзменения = Выборка.АвторИзменения;
		НоваяСтрока.Сотрудник = Выборка.Сотрудник; 
		
		Если Выборка.Извне = Истина Тогда
			НоваяСтрока.Картинка = 2;
		Иначе
			НоваяСтрока.Картинка = 1;
		КонецЕсли;

		Если Выборка.Состояние = Справочники.СостоянияОригиналовПервичныхДокументов.ОригиналПолучен Тогда
			НоваяСтрока.ОригиналПолученКартинка = 1;
		Иначе
			НоваяСтрока.ОригиналПолученКартинка = 0;
		КонецЕсли;

	КонецЦикла;
	
	КомплектПечатныхФорм.Сортировать("Представление");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсеПечатныеФормы()

	ЗаполнитьСписокПечатныхФормПоСсылке();
	ЗаполнитьПервоначальныйСписокПечатныхФорм();

	УдалитьДубликатыФорм();

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокумент КАК ПервичныйДокумент,
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокументПредставление КАК Представление,
	               |	СостоянияОригиналовПервичныхДокументов.АвторИзменения КАК АвторИзменения,
	               |	СостоянияОригиналовПервичныхДокументов.ДатаПоследнегоИзменения КАК ДатаПоследнегоИзменения,
	               |	СостоянияОригиналовПервичныхДокументов.Сотрудник КАК Сотрудник
	               |ИЗ
	               |	РегистрСведений.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	               |ГДЕ
	               |	ТИПЗНАЧЕНИЯ(СостоянияОригиналовПервичныхДокументов.Владелец) = &Тип
	               |	И СостоянияОригиналовПервичныхДокументов.ДатаПоследнегоИзменения МЕЖДУ &ДатаНачала И &ДатаОкончания
	               |	И СостоянияОригиналовПервичныхДокументов.ФормаИзвне
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокумент,
	               |	СостоянияОригиналовПервичныхДокументов.ПервичныйДокументПредставление,
	               |	СостоянияОригиналовПервичныхДокументов.АвторИзменения,
	               |	СостоянияОригиналовПервичныхДокументов.ДатаПоследнегоИзменения,
	               |	СостоянияОригиналовПервичныхДокументов.Сотрудник";

	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Тип","ТИП ("+ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Владелец)+")");
	Запрос.УстановитьПараметр("ДатаНачала",НачалоМесяца(НачалоДня(ТекущаяДатаСеанса())));
	Запрос.УстановитьПараметр("ДатаОкончания",КонецМесяца(КонецДня(ТекущаяДатаСеанса())));

	Выборка = Запрос.Выполнить().Выбрать();

	Пока Выборка.Следующий() Цикл
		НоваяСтрока = КомплектПечатныхФорм.Добавить();
		НоваяСтрока.ИмяМакета = Выборка.ПервичныйДокумент;
		НоваяСтрока.Представление = Выборка.Представление;
		НоваяСтрока.Извне = Истина;
		НоваяСтрока.Картинка = 2;
		НоваяСтрока.ОригиналПолученКартинка = 0;
		НоваяСтрока.ДатаПоследнегоИзменения =  Выборка.ДатаПоследнегоИзменения;
		НоваяСтрока.АвторИзменения = Выборка.АвторИзменения;
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;	
	КонецЦикла;
	
	УдалитьДубликатыФорм();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНеОтслеживаемые()
	
	Отбор = Новый Структура("Состояние",ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка"));
	НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Отбор);
	Для Каждого Строка Из НайденныеСтроки Цикл 
		 КомплектПечатныхФорм.Удалить(Строка);
	КонецЦикла;
	 
КонецПроцедуры
	
&НаСервере
Процедура УдалитьДубликатыФорм()

	УдаляемыеПечатныеФормы = Новый Массив;
	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		ТЧ = УчетОригиналовПервичныхДокументов.ТабличнаяЧастьМногосотрудниковаДокумента(Запись.Владелец); 
		Если ТЧ <> "" Тогда
			Отбор = Новый Структура("Представление", Строка.Представление);
		Иначе
			Отбор = Новый Структура("ИмяМакета", Строка.ИмяМакета);
		КонецЕсли;
		НайденныеДубли = КомплектПечатныхФорм.НайтиСтроки(Отбор);
		Если НайденныеДубли.Количество() > 1 Тогда
			НайденныеДубли.Удалить(0);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(УдаляемыеПечатныеФормы, НайденныеДубли, Истина);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ПечатнаяФорма Из УдаляемыеПечатныеФормы Цикл
		КомплектПечатныхФорм.Удалить(ПечатнаяФорма);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПоказатьВсеНаСервере() 

	Элементы.ПоказатьВсе.Пометка = Истина;
	Элементы.ПоказатьОтслеживаемые.Пометка = Ложь;
	ФильтрПечатныхФорм = "Все";
	
	ОчиститьНеОтслеживаемые();
	ЗаполнитьВсеПечатныеФормы();

КонецПроцедуры

&НаСервере
Процедура ПоказатьОтслеживаемыеНаСервере() 

	Элементы.ПоказатьВсе.Пометка = Ложь;
	Элементы.ПоказатьОтслеживаемые.Пометка = Истина;
	ФильтрПечатныхФорм = "Отслеживаемые";
	
	ОчиститьНеОтслеживаемые();
	ЗаполнитьСписокПечатныхФормПоСсылке();
	УдалитьДубликатыФорм();
КонецПроцедуры

&НаСервере
Процедура УстановитьФильтрПечатныхФорм() 
	
	Если ФильтрПечатныхФорм = "Отслеживаемые" Тогда
		ПоказатьОтслеживаемыеНаСервере();
	Иначе 
		ПоказатьВсеНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСсылкуНаОригинал() 

	// Для отключения проверки конфигурации.
	СвойстваЗаписи = Новый Структура("Ссылка", Запись.Владелец);
	
	Документ = СвойстваЗаписи.Ссылка.ПолучитьОбъект();
	ТипДокумента = Метаданные.НайтиПоПолномуИмени(ОбщегоНазначения.ИмяТаблицыПоСсылке(Запись.Владелец));

	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПрефиксацияОбъектов") Тогда
		Значения = Новый Структура("Документ,Номер,Дата",СокрЛП(ТипДокумента),
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Документ.Номер, Истина, Истина),Формат(Документ.Дата,НСтр("ru='ДЛФ=DD'")));
		СсылкаНаДокумент = НСтр("ru='[Документ] № [Номер] от [Дата]'");
		СсылкаНаДокумент = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(СсылкаНаДокумент,Значения);
	Иначе
		СсылкаНаДокумент = Запись.Владелец;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция НайтиСостояниеВСправочнике(ИмяСостояния)

	СостояниеОригинала = Справочники.СостоянияОригиналовПервичныхДокументов.НайтиПоНаименованию(ИмяСостояния);

	Возврат СостояниеОригинала

КонецФункции

&НаКлиенте
Процедура УстановитьОбщееСостояние()

	КоличествоЗаписываемых = 0;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			КоличествоЗаписываемых = КоличествоЗаписываемых + 1;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Строка Из КомплектПечатныхФорм Цикл
		Если ЗначениеЗаполнено(Строка.Состояние) Тогда
			Отбор = Новый Структура("Состояние",Строка.Состояние);
			НайденныеСтроки = КомплектПечатныхФорм.НайтиСтроки(Отбор);

			Если НайденныеСтроки.Количество() = КомплектПечатныхФорм.Количество() Или КоличествоЗаписываемых = 1  Тогда
				Запись.Состояние = Строка.Состояние;
			Иначе
				Запись.Состояние = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ОригиналыНеВсе");
			КонецЕсли;

			Прервать;
		КонецЕсли;
	КонецЦикла

КонецПроцедуры

&НаСервере
Процедура ЗаписатьСостоянияОригиналовПервичныхДокументов()

	ПроверкаЗаписьСостоянияОригинала = РегистрыСведений.СостоянияОригиналовПервичныхДокументов.СоздатьНаборЗаписей();
	ПроверкаЗаписьСостоянияОригинала.Отбор.Владелец.Установить(Запись.Владелец);
	ПроверкаЗаписьСостоянияОригинала.Прочитать(); 

	Если ПроверкаЗаписьСостоянияОригинала.Количество() = 0 Тогда
		РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьОбщееСостояниеОригиналаДокумента(Запись.Владелец,Запись.Состояние);
	КонецЕсли;

	Если КомплектПечатныхФорм.Количество()<> 0 Тогда
		Для Каждого ПечатнаяФорма Из КомплектПечатныхФорм Цикл
			
			Если ЗначениеЗаполнено(ПечатнаяФорма.Состояние) Тогда
				ТЧ = УчетОригиналовПервичныхДокументов.ТабличнаяЧастьМногосотрудниковаДокумента(Запись.Владелец); 
				Если ТЧ = "" Тогда
					ПроверкаЗаписьСостоянияОригинала.Отбор.ПервичныйДокумент.Установить(ПечатнаяФорма.ИмяМакета);
					ПроверкаЗаписьСостоянияОригинала.Прочитать();
				Иначе
				 	ПроверкаЗаписьСостоянияОригинала.Отбор.ПервичныйДокумент.Установить(ПечатнаяФорма.ИмяМакета);
					ПроверкаЗаписьСостоянияОригинала.Отбор.Сотрудник.Установить(ПечатнаяФорма.Сотрудник);
					ПроверкаЗаписьСостоянияОригинала.Прочитать();
				КонецЕсли;
				Если ПроверкаЗаписьСостоянияОригинала.Количество() > 0 Тогда

					Если ПроверкаЗаписьСостоянияОригинала[0].Состояние <> ПечатнаяФорма.Состояние Тогда
						РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Запись.Владелец,
							ПечатнаяФорма.ИмяМакета,ПечатнаяФорма.Представление,ПечатнаяФорма.Состояние,ПечатнаяФорма.Извне, ПечатнаяФорма.Сотрудник);
					КонецЕсли;
				Иначе
						РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьСостояниеОригиналаДокументаПоПечатнымФормам(Запись.Владелец,
							ПечатнаяФорма.ИмяМакета,ПечатнаяФорма.Представление,ПечатнаяФорма.Состояние,ПечатнаяФорма.Извне,ПечатнаяФорма.Сотрудник);
				
				КонецЕсли;
			КонецЕсли;

		КонецЦикла;
	КонецЕсли;
	РегистрыСведений.СостоянияОригиналовПервичныхДокументов.ЗаписатьОбщееСостояниеОригиналаДокумента(Запись.Владелец,Запись.Состояние);
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки(ВосстанавливатьФильтр)

	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("РегистрСведений.СостоянияОригиналовПервичныхДокументов.Форма.ИзменениеСостоянийОригиналовПервичныхДокументов","ФильтрПечатныхФорм");

	Если ВосстанавливатьФильтр Тогда 
		Если ТипЗнч(Настройки) = Тип("Структура") Тогда
			ФильтрПечатныхФорм = Настройки.ФильтрПечатныхФорм;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	ИменаСохраняемыхРеквизитов = "ФильтрПечатныхФорм";

	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтотОбъект);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("РегистрСведений.СостоянияОригиналовПервичныхДокументов.Форма.ИзменениеСостоянийОригиналовПервичныхДокументов","ФильтрПечатныхФорм",Настройки);

КонецПроцедуры

#КонецОбласти
