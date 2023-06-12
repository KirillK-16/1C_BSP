
#Область СлужебныйПрограммныйИнтерфейс

// Процедура регламентного задания ОбработкаОповещенийПользователей
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ОбработкаОповещенийПользователей() Экспорт
	
КонецПроцедуры

// Выполняет отправку оповещений сеансам пользователей
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ДоставитьОповещения(ДоставляемыеОповещения) Экспорт
	
КонецПроцедуры

// См. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	Настройки - см. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.Настройки
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
КонецПроцедуры

// См. ЗагрузкаДанныхИзФайлаПереопределяемый.ПриОпределенииСправочниковДляЗагрузкиДанных.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	Типы - См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
КонецПроцедуры

#КонецОбласти