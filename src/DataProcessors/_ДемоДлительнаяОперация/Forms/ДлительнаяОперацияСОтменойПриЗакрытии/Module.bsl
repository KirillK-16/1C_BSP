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
	
	СекундПередЗакрытием = Параметры.СекундПередЗакрытием;
	
	Если Не ЗначениеЗаполнено(СекундПередЗакрытием) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	ДополнительныеПараметры = Обработки._ДемоДлительнаяОперация.НовыеДополнительныеПараметрыВыполнения();
	ДополнительныеПараметры.ДлительностьРасчета = Цел(СекундПередЗакрытием) + 1;
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"Обработки._ДемоДлительнаяОперация.РассчитатьЗначение", 0, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(СекундПередЗакрытием) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьРезультат", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
	ПодключитьОбработчикОжидания("ЗакрытьФорму", СекундПередЗакрытием, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДлительнаяОперацияСОтменойПриЗакрытии" Тогда
		Источник.ОповещениеОбработаноВЗакрытойФорме = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРезультат(Результат, Контекст) Экспорт
	
	Если Результат = Неопределено Тогда  // отменено пользователем
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти
