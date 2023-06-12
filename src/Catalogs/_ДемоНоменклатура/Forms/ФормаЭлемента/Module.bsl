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
	
	// Установка значения реквизита АдресКартинки.
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Не Объект.ФайлКартинки.Пустая() Тогда
			АдресКартинки = ПолучитьНавигационнуюСсылкуКартинки(Объект.ФайлКартинки, УникальныйИдентификатор)
		Иначе
			АдресКартинки = "";
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриСозданииФормыЗначенияДоступа(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ЦентрМониторинга
	
	// Подсчитываем количество созданий формы, стандартный разделитель ".".
	Комментарий = Строка(ПолучитьСкоростьКлиентскогоСоединения());
	ЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики("Справочник._ДемоНоменклатура.ПриСозданииНаСервере", 1, Комментарий);
	
	// Подсчитываем количество созданий формы с картинкой и без, не стандартный разделитель ";".
	Если ЗначениеЗаполнено(АдресКартинки) Тогда
		ПараметрБизнесСтатистики = "ЕстьКартинка";
	Иначе
		ПараметрБизнесСтатистики = "НетКартинки";
	КонецЕсли;
	ИмяОперации = "Справочник;_ДемоНоменклатура;ПриСозданииНаСервере;" + ПараметрБизнесСтатистики;
	ЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, 1, Комментарий,";");
	
	// Конец СтандартныеПодсистемы.ЦентрМониторинга
	
	// Локализация
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	// Конец Локализация
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	
	ПараметрыПоля = РаботаСФайлами.ПолеФайла();
	ПараметрыПоля.Размещение  = "ГруппаКартинка";
	ПараметрыПоля.ПутьКДанным = "Объект.ФайлКартинки";
	ПараметрыПоля.ПутьКДаннымИзображения = "АдресКартинки";
	
	ДобавляемыеЭлементы = Новый Массив;
	ДобавляемыеЭлементы.Добавить(ПараметрыГиперссылки);
	ДобавляемыеЭлементы.Добавить(ПараметрыПоля);
	
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ДобавляемыеЭлементы);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// СтандартныеПодсистемы.Мультиязычность
	МультиязычностьСервер.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.Мультиязычность
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	УникальныйИдентификаторЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени("_ДемоПриОткрытииРучнойЗамер", Ложь, Ложь);
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УникальныйИдентификаторЗамера);
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не ТекущийОбъект.ФайлКартинки.Пустая() Тогда
		АдресКартинки = ПолучитьНавигационнуюСсылкуКартинки(ТекущийОбъект.ФайлКартинки, УникальныйИдентификатор)
	Иначе
		АдресКартинки = "";
	КонецЕсли;
	
	ЗаписанныйВидНоменклатуры = ТекущийОбъект.ВидНоменклатуры;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Мультиязычность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Мультиязычность
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.Мультиязычность
	МультиязычностьСервер.ПередЗаписьюНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Мультиязычность
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписанныйВидНоменклатуры = ТекущийОбъект.ВидНоменклатуры;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайлами.ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи, Параметры);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	// Локализация
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиФормыОбъектаСклонения(ЭтотОбъект, Объект.Наименование, ТекущийОбъект.Ссылка);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	// Конец Локализация
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.Мультиязычность
	МультиязычностьСервер.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Мультиязычность
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.Свойства
	ОбновитьЭлементыДополнительныхРеквизитов();
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПроисхожденияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// Локализация
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставление(ЭтотОбъект, Объект.Наименование);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	// Конец Локализация
	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
				ПараметрыПеретаскивания, СтандартнаяОбработка);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// Локализация
// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ПоказатьСклонение(ЭтотОбъект, Объект.Наименование);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
// Конец Локализация

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

&НаКлиенте
Процедура ЗагрузкаИзФайла(Команда)
	
	ПараметрыЗагрузки = ЗагрузкаДанныхИзФайлаКлиент.ПараметрыЗагрузкиДанных();
	ПараметрыЗагрузки.ПолноеИмяТабличнойЧасти = "_ДемоНоменклатура.Аналоги";
	ПараметрыЗагрузки.Заголовок = НСтр("ru = 'Загрузка списка аналогов из файла'");
	
	// Описание колонок для макета загрузки комплектации.
	ПараметрыЗагрузки.КолонкиМакета = ОписаниеКолонокМакетаДляЗагрузкиАналогов();
	ПараметрыЗагрузки.ДополнительныеПараметры = Новый Структура("ВидНоменклатуры", Объект.ВидНоменклатуры);
	
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьАналогиИзФайлаЗавершение", ЭтотОбъект);
	ЗагрузкаДанныхИзФайлаКлиент.ПоказатьФормуЗагрузки(ПараметрыЗагрузки, Оповещение);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)

	РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);

КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьНавигационнуюСсылкуКартинки(ФайлКартинки, ИдентификаторФормы)
	
	Попытка
		
		ПараметрыФайла = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ПараметрыФайла.ИдентификаторФормы = ИдентификаторФормы;
		ПараметрыФайла.ВызыватьИсключение = Ложь;
		Возврат РаботаСФайлами.ДанныеФайла(ФайлКартинки, ПараметрыФайла).СсылкаНаДвоичныеДанныеФайла;
		
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект,,
		ЗаписанныйВидНоменклатуры <> Объект.ВидНоменклатуры);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

&НаСервере
Функция ОписаниеКолонокМакетаДляЗагрузкиАналогов()
	
	КолонкиМакета = ЗагрузкаДанныхИзФайла.СформироватьОписаниеКолонок(Объект.Аналоги);
	ЗагрузкаДанныхИзФайлаКлиентСервер.УдалитьКолонкуМакета("Аналог", КолонкиМакета);
	
	Если Объект.ВидНоменклатуры.Наименование = "Услуга" Тогда
		// У услуг нет штрихкода
		Колонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета("ШтрихкодАртикул", ОбщегоНазначения.ОписаниеТипаСтрока(20), НСтр("ru = 'Артикул'"));
	Иначе
		Колонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета("ШтрихкодАртикул", ОбщегоНазначения.ОписаниеТипаСтрока(20), НСтр("ru = 'Штрихкод и Артикул'"));
	КонецЕсли;
	Колонка.ОбязательнаДляЗаполнения = Истина;
	Колонка.Позиция = 1;
	Колонка.Группа = НСтр("ru='Номенклатура'");
	Колонка.Родитель = "Аналог";
	Колонка.Подсказка = НСтр("ru='Штрихкод аналогичного товара для сопоставления.'");
	КолонкиМакета.Добавить(Колонка);
	
	Колонка = ЗагрузкаДанныхИзФайлаКлиентСервер.ОписаниеКолонкиМакета("Наименование", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	Колонка.Группа = НСтр("ru='Номенклатура'");
	Колонка.Заголовок = НСтр("ru='Номенклатура'");
	Колонка.Родитель = "Аналог";
	Колонка.Позиция = 2;
	Колонка.Подсказка = НСтр("ru='Наименование аналогичного товара, который полностью идентичен
	|по своему функциональному назначению и техническим характеристикам.'");
	КолонкиМакета.Добавить(Колонка);
	
	Колонка = ЗагрузкаДанныхИзФайлаКлиентСервер.КолонкаМакета("Совместимость", КолонкиМакета);
	Колонка.Заголовок = НСтр("ru='Совместимость'");
	Колонка.Позиция = 3;
	
	Возврат КолонкиМакета;
КонецФункции

&НаКлиенте
Процедура ЗагрузитьАналогиИзФайлаЗавершение(АдресЗагруженныхДанных, ДополнительныеПараметры) Экспорт
	
	Если АдресЗагруженныхДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьАналогиИзФайлаНаСервере(АдресЗагруженныхДанных);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьАналогиИзФайлаНаСервере(АдресЗагруженныхДанных)

	ЗагруженныеДанные = ПолучитьИзВременногоХранилища(АдресЗагруженныхДанных);
	
	ТоварыДобавлены = Ложь;
	
	Для каждого СтрокаТаблицы Из ЗагруженныеДанные Цикл 
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Аналог) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрокаТовары = Объект.Аналоги.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТовары, СтрокаТаблицы);
		ТоварыДобавлены = Истина;
	КонецЦикла;
	
	Если ТоварыДобавлены Тогда
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)
	МультиязычностьКлиент.ПриОткрытии(ЭтотОбъект, Объект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти