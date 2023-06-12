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
	
	ЭтоТовары = Не ОбщегоНазначения.ПустойБуферОбмена("Товары");
	Элементы.ТоварыВставитьСтроки.Доступность = ЭтоТовары;
	Элементы.ТоварыВставитьСтрокиМеню.Доступность = ЭтоТовары;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.Комментарий.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		
		Элементы.ТоварыНомерСтроки.Видимость = Ложь;
		Элементы.СчетаНаОплатуНомерСтроки.Видимость = Ложь;
		
		Элементы.ГруппаОсновное.ВыравниваниеЭлементовИЗаголовков =
			ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		
		Элементы.ГруппаДополнительно.ВыравниваниеЭлементовИЗаголовков =
			ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
	КонецЕсли;
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаДокумента(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ДанныеСкопированыВБуферОбмена" Тогда
		ЭтоТовары = (Параметр.ИсточникКопирования = "Товары");
		Элементы.ТоварыВставитьСтроки.Доступность = ЭтоТовары;
		Элементы.ТоварыВставитьСтрокиМеню.Доступность = ЭтоТовары;
	КонецЕсли;
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов	
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаДокумента(ИмяСобытия,ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура Подключаемый_ДекорацияСостояниеОригиналаНажатие()

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОткрытьМенюВыбораСостояния(ЭтотОбъект,Элементы.ДекорацияСостояниеОригинала);
	//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если Элементы.Товары.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;	
	КонецЕсли;
	
	СкопироватьСтрокиНаСервере();
	ПоказатьОповещениеПользователя(НСтр("ru = 'Копирование в буфер обмена'"), Окно.ПолучитьНавигационнуюСсылку(), 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Скопировано товаров: %1'"), Элементы.Товары.ВыделенныеСтроки.Количество()));
	Оповестить("ДанныеСкопированыВБуферОбмена", Новый Структура("ИсточникКопирования", "Товары"), Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьСтроки(Команда)
	
	Количество = ВставитьСтрокиНаСервере();
	Если Количество > 0 Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Вставка из буфера обмена'"), Окно.ПолучитьНавигационнуюСсылку(), 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Вставлено товаров: %1'"), Количество));
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкопироватьСтрокиНаСервере()
	
	ОбщегоНазначения.СкопироватьСтрокиВБуферОбмена(Объект.Товары, Элементы.Товары.ВыделенныеСтроки, "Товары");

КонецПроцедуры

&НаСервере
Функция ВставитьСтрокиНаСервере()
	
	ДанныеИзБуфераОбмена = ОбщегоНазначения.СтрокиИзБуфераОбмена();
	Если ДанныеИзБуфераОбмена.Источник <> "Товары" Тогда
		Возврат 0;
	КонецЕсли;
		
	Таблица = ДанныеИзБуфераОбмена.Данные;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		ЗаполнитьЗначенияСвойств(Объект.Товары.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	Возврат Таблица.Количество();
	
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти