///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("МассивУзловПланаОбмена", Новый Массив);
	ПараметрыОткрытия.Вставить("ОтборПоДатеВозникновения", Дата(1,1,1));
	ПараметрыОткрытия.Вставить("ОтборУзловОбменов", Новый Массив);
	ПараметрыОткрытия.Вставить("ОтборТипыПредупреждений", Новый Массив); 
	ПараметрыОткрытия.Вставить("ТолькоСкрытыеЗаписи", Истина);
	
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.ПредупрежденияСинхронизаций", ПараметрыОткрытия,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
