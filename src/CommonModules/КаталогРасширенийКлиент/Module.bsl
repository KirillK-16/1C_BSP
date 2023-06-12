// @strict-types

#Область ПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//	Параметры - см. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.Параметры
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
КонецПроцедуры

// Открывает форму объекта расширения из каталога расширений
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
// 	ПубличныйИдентификатор - Строка - публичный идентификатор расширения из Менеджера сервиса
// 	ОписаниеОповещения - ОписаниеОповещения - необязательный, позволяет обработать закрытие формы.
// 		Процедура, которая будет обрабатывать вызов описания оповещения, в качестве первого параметра будет получать
// 		значение типа "ПеречислениеСсылка.СостоянияРасширений", описывающее состояние расширения в момент закрытия формы
// 		(подробности см. в описании метода "ОткрытьФорму" глобального контекста).
//
Процедура ОткрытьОбъектРасширения(Знач ПубличныйИдентификатор, Знач ОписаниеОповещения = Неопределено) Экспорт
КонецПроцедуры
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает каталог расширений.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ОткрытьКаталогРасширений() Экспорт 
КонецПроцедуры

#КонецОбласти
