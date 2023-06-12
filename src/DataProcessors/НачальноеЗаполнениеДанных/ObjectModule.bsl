///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру локализуемых реквизитов
// 
// Параметры:
//  СписокРеквизитов - КоллекцияОбъектовМетаданных
//  МетаданныеИсточник - ОбъектМетаданныхСправочник, Неопределено, ОбъектМетаданныхТабличнаяЧасть - или общие реквизиты,
//      или метаданные табличных частей
// 
// Возвращаемое значение:
//  Структура
//
Функция ПолучитьЛокализуемыеРеквизиты(СписокРеквизитов, МетаданныеИсточник = Неопределено)
	
	ЛокализуемыеРеквизиты = Новый Структура;
	МетаданныеИспользовать = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать;
	
	Если Языки.Количество() = 1 Тогда
		Возврат ЛокализуемыеРеквизиты;
	КонецЕсли;
	
	Для каждого Реквизит Из СписокРеквизитов Цикл
		
		Если НЕ МетаданныеИсточник = Неопределено И НЕ Реквизит.Состав.Найти(МетаданныеИсточник).Использование = МетаданныеИспользовать Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыРеквизита = Новый Структура("Имя, Тип");
		ЗаполнитьЗначенияСвойств(ПараметрыРеквизита, Реквизит);
		
		Если НЕ Прав(Реквизит.Имя, 5) = "Язык1" Тогда
			Продолжить;
		КонецЕсли;
		
		ЛокализуемыеРеквизиты.Вставить(СтрЗаменить(Реквизит.Имя, "Язык1", ""), ПараметрыРеквизита);
		
	КонецЦикла;
	
	Возврат ЛокализуемыеРеквизиты;
	
КонецФункции

// Параметры:
//   МетаданныеОбъекта - ОбъектМетаданныхСправочник
//   ТабличнаяЧасть - Булево
//   ЕстьГруппы - Булево
// Возвращаемое значение:
//   Структура
// 
Функция ПолучитьРеквизитыМетаданныхОбъекта(МетаданныеОбъекта, ИмяКлючевогоРеквизита, ТабличнаяЧасть = Ложь, ЕстьГруппы = Ложь) Экспорт
	
	СтруктураОбъекта = Новый Структура;
	ЕстьГруппы = ?(ТабличнаяЧасть, ЕстьГруппы, Ложь);
	ТипСтрока = Тип("Строка");
	
	Если ТабличнаяЧасть Тогда
		ЛокализуемыеРеквизиты = ПолучитьЛокализуемыеРеквизиты(МетаданныеОбъекта.Реквизиты);
	Иначе
		ЛокализуемыеРеквизиты = ПолучитьЛокализуемыеРеквизиты(Метаданные.ОбщиеРеквизиты, МетаданныеОбъекта);
		
		Для Каждого Реквизит Из МетаданныеОбъекта.СтандартныеРеквизиты Цикл
			
			Если СтрНайти("ЭтоГруппа", Реквизит.Имя) > 0 Тогда
				ЕстьГруппы = Истина;
				Продолжить;
			ИначеЕсли СтрНайти("Ссылка, Предопределенный, ПометкаУдаления, ЭтоГруппа", Реквизит.Имя) > 0 Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураРеквизита = ИнициализироватьСтруктуруРеквизита();
			СтруктураРеквизита.ТипЗначения  = Реквизит.Тип;
			СтруктураРеквизита.Исключаемый  = РеквизитИсключается(Реквизит, МетаданныеОбъекта);
			СтруктураРеквизита.Локализуемый = ЛокализуемыеРеквизиты.Свойство(Реквизит.Имя);
			СтруктураРеквизита.Строковый    = НЕ СтруктураРеквизита.Локализуемый
				И НЕ Реквизит.Имя = ИмяКлючевогоРеквизита
				И СтруктураРеквизита.ТипЗначения.СодержитТип(ТипСтрока);
			
			СтруктураОбъекта.Вставить(Реквизит.Имя, СтруктураРеквизита);
			
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		
		Если Лев(Прав(Реквизит.Имя, 5),4) = "Язык" Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураРеквизита = ИнициализироватьСтруктуруРеквизита();
		СтруктураРеквизита.ТипЗначения      = Реквизит.Тип;
		СтруктураРеквизита.Исключаемый      = РеквизитИсключается(Реквизит, МетаданныеОбъекта);
		СтруктураРеквизита.Локализуемый     = ЛокализуемыеРеквизиты.Свойство(Реквизит.Имя);
		СтруктураРеквизита.Строковый        = СтруктураРеквизита.ТипЗначения.СодержитТип(ТипСтрока);
		
		СтруктураОбъекта.Вставить(Реквизит.Имя, СтруктураРеквизита);
		
	КонецЦикла;
	
	Если Не ТабличнаяЧасть Тогда
		
		Для каждого МетаданныеТЧОбъекта Из МетаданныеОбъекта.ТабличныеЧасти Цикл
			
			РеквизитыТЧОбъекта = ПолучитьРеквизитыМетаданныхОбъекта(МетаданныеТЧОбъекта, ИмяКлючевогоРеквизита, Истина);
			
			СтруктураРеквизита = ИнициализироватьСтруктуруРеквизита();
			СтруктураРеквизита.Реквизиты = РеквизитыТЧОбъекта;
			СтруктураРеквизита.Исключаемый = ТаблицаИсключается(РеквизитыТЧОбъекта, МетаданныеТЧОбъекта);
			
			Если РеквизитыТЧОбъекта.Количество() > 2
				Или Не (РеквизитыТЧОбъекта.Количество() = 1 И РеквизитыТЧОбъекта.Свойство(ИмяКлючевогоРеквизита)) Тогда
				СтруктураОбъекта.Вставить(МетаданныеТЧОбъекта.Имя, СтруктураРеквизита);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СтруктураОбъекта;
	
КонецФункции

Функция РеквизитИсключается(Реквизит, МетаданныеОбъекта)
	
	Возврат РеквизитИсключаетсяПоИмени(Реквизит.Имя, МетаданныеОбъекта.ПолноеИмя())
			Или РеквизитИсключаетсяПоТипу(Реквизит.Тип) 
			Или Лев(ВРег(Реквизит.Имя),7) = "УДАЛИТЬ";
	
КонецФункции

Функция ТаблицаИсключается(Реквизиты, МетаданныеОбъекта)
	
	Исключаемый = Лев(ВРег(МетаданныеОбъекта.Имя),7) = "УДАЛИТЬ" ИЛИ Реквизиты.Количество() = 0;
	ЕстьНеИсключаемыеРеквизиты = Ложь;
	
	Для Каждого Реквизит Из Реквизиты Цикл
		Если Исключаемый Тогда
			Реквизит.Значение.Исключаемый = Истина;
		Иначе
			ЕстьНеИсключаемыеРеквизиты = ЕстьНеИсключаемыеРеквизиты ИЛИ Не Реквизит.Значение.Исключаемый;
		КонецЕсли;
	КонецЦикла;
	
	Исключаемый = Исключаемый Или НЕ ЕстьНеИсключаемыеРеквизиты;
	
	Возврат Исключаемый;
	
КонецФункции

Функция РеквизитИсключаетсяПоИмени(ИмяРеквизита, ИмяОбъекта)
	
	Возврат ИмяРеквизита = "ПериодДействияБазовый" И СтрНачинаетсяС(ИмяОбъекта, "ПланВидовРасчета");
	
КонецФункции

Функция РеквизитИсключаетсяПоТипу(ТипРеквизита)
	
	ОписаниеТиповХранилище = Новый ОписаниеТипов("ХранилищеЗначения");
	ОписаниеТиповУИД = Новый ОписаниеТипов("УникальныйИдентификатор");
	ОписаниеТиповОписаниеТипов = Новый ОписаниеТипов("ОписаниеТипов");
	ОписаниеТиповВидСчета = Новый ОписаниеТипов("ВидСчета");
	
	Если ТипРеквизита = Неопределено Тогда
		Возврат Истина;
	ИначеЕсли ТипРеквизита = Тип("ХранилищеЗначения") Или ТипРеквизита = ОписаниеТиповХранилище Тогда
		Возврат Истина;
	ИначеЕсли ТипРеквизита = Тип("УникальныйИдентификатор") Или ТипРеквизита = ОписаниеТиповУИД Тогда
		Возврат Истина;
	ИначеЕсли ТипРеквизита = Тип("ОписаниеТипов") Или ТипРеквизита = ОписаниеТиповОписаниеТипов Тогда
		Возврат Ложь;
	ИначеЕсли ТипРеквизита = Тип("ВидСчета") Или ТипРеквизита = ОписаниеТиповВидСчета Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка");
	ОписаниеТиповБулево = Новый ОписаниеТипов("Булево");
	ОписаниеТиповДата = Новый ОписаниеТипов("Дата");
	ОписаниеТиповЧисло = Новый ОписаниеТипов("Число");
	
	Простой = Истина;
	Для каждого Тип Из ТипРеквизита.Типы() Цикл
		Простой = Простой И (ОписаниеТиповСтрока.СодержитТип(Тип)
								Или ОписаниеТиповБулево.СодержитТип(Тип)
								Или ОписаниеТиповДата.СодержитТип(Тип)
								Или ОписаниеТиповЧисло.СодержитТип(Тип));
	КонецЦикла;
	
	Если Простой Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// составной
	Если ТипРеквизита.Типы().Количество() > 1 Тогда
		Возврат Истина;
	КонецЕсли;
	
	РеквизитПоТипу = ТипРеквизита.ПривестиЗначение();
	
	Если БизнесПроцессы.ТипВсеСсылкиТочекМаршрутаБизнесПроцессов().СодержитТип(ТипЗнч(РеквизитПоТипу)) Тогда
		Возврат Истина;
	КонецЕсли;
	
	МетаданныеПоТипу = РеквизитПоТипу.Метаданные();
	МетаданныеПоТипуРаздел = СтрЗаменить(МетаданныеПоТипу.ПолноеИмя(), "."+МетаданныеПоТипу.Имя, "");
	
	Если СтрНайти("ПланОбмена, Справочник, ПланВидовХарактеристик, ПланСчетов, ПланВидовРасчета, Перечисление", МетаданныеПоТипуРаздел) > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ИнициализироватьСтруктуруРеквизита()
	
	Возврат Новый Структура("ТипЗначения, Исключаемый, Реквизиты, Локализуемый, Строковый");

КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли