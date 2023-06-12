///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события ПриОткрытии поля ввода формы для открытия формы ввода значения реквизита на разных языках.
//
// Параметры:
//  Форма   - ФормаКлиентскогоПриложения - форма содержащая мультиязычные реквизиты.
//  Объект  - ДанныеФормыСтруктура:
//   * Ссылка - ЛюбаяСсылка
//  Элемент - ПолеФормы - элемент формы, для которого будет открыта форма ввода на разных языках.
//  СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ПриОткрытии(Форма, Объект, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПутьКДанным = Форма.ПараметрыМультиязычныхРеквизитов[Элемент.Имя];
	
	ПозицияТочки = СтрНайти(ПутьКДанным, ".");
	ИмяРеквизита = ?(ПозицияТочки > 0, Сред(ПутьКДанным, ПозицияТочки + 1), ПутьКДанным);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Объект",          Объект);
	ПараметрыФормы.Вставить("ИмяРеквизита",    ИмяРеквизита);
	ПараметрыФормы.Вставить("ТекущиеЗначение", Элемент.ТекстРедактирования);
	ПараметрыФормы.Вставить("ТолькоПросмотр",  Элемент.ТолькоПросмотр);
	
	Если Объект.Свойство("Представления") Тогда
		ПараметрыФормы.Вставить("Представления", Объект.Представления);
	Иначе
		Представления = Новый Структура();
		
		Представления.Вставить(ИмяРеквизита, Объект[ИмяРеквизита]);
		Представления.Вставить(ИмяРеквизита + "Язык1", Объект[ИмяРеквизита + "Язык1"]);
		Представления.Вставить(ИмяРеквизита + "Язык2", Объект[ИмяРеквизита + "Язык2"]);
		
		ПараметрыФормы.Вставить("ЗначенияРеквизитов", Представления);
		
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма",        Форма);
	ДополнительныеПараметры.Вставить("Объект",       Объект);
	ДополнительныеПараметры.Вставить("ИмяРеквизита", ИмяРеквизита);
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСтрокНаРазныхЯзыках", МультиязычностьКлиент, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.ВводНаРазныхЯзыках", ПараметрыФормы,,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФормуРегиональныхНастроек(ОписаниеОповещения = Неопределено, Параметры = Неопределено) Экспорт
	
	ОткрытьФорму("ОбщаяФорма.РегиональныеНастройки", Параметры, , , , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ПослеВводаСтрокНаРазныхЯзыках(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Модифицированность Тогда
		ДополнительныеПараметры.Форма.Модифицированность = Истина;
	КонецЕсли;
	
	Объект = ДополнительныеПараметры.Объект;
	Если Результат.ХранениеВТабличнойЧасти Тогда
		
		Для каждого Представление Из Результат.ЗначенияНаРазныхЯзыках Цикл
			Отбор = Новый Структура("КодЯзыка", Представление.КодЯзыка);
			НайденныеСтроки = Объект.Представления.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				Если ПустаяСтрока(Представление.ЗначениеРеквизита) 
					И СтрСравнить(Результат.ОсновнойЯзык, Представление.КодЯзыка) <> 0 Тогда
						Объект.Представления.Удалить(НайденныеСтроки[0]);
					Продолжить;
				КонецЕсли;
				СтрокаПредставлений = НайденныеСтроки[0];
			Иначе
				СтрокаПредставлений = Объект.Представления.Добавить();
				СтрокаПредставлений.КодЯзыка = Представление.КодЯзыка;
			КонецЕсли;
			СтрокаПредставлений[ДополнительныеПараметры.ИмяРеквизита] = Представление.ЗначениеРеквизита;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для каждого Представление Из Результат.ЗначенияНаРазныхЯзыках Цикл
		Если ЗначениеЗаполнено(Представление.Суффикс) Тогда
			ИмяРеквизитаНаДругомЯзыке = ДополнительныеПараметры.ИмяРеквизита + Представление.Суффикс;
			Если Объект.Свойство(ИмяРеквизитаНаДругомЯзыке) Тогда
				Объект[ИмяРеквизитаНаДругомЯзыке]= Представление.ЗначениеРеквизита;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
		
	Если Результат.Свойство("СтрокаНаТекущемЯзыке") Тогда
		Объект[ДополнительныеПараметры.ИмяРеквизита] = Результат.СтрокаНаТекущемЯзыке;
	КонецЕсли;
	
	Оповестить("ПослеВводаСтрокНаРазныхЯзыках", ДополнительныеПараметры.Форма);
	
КонецПроцедуры

#КонецОбласти
