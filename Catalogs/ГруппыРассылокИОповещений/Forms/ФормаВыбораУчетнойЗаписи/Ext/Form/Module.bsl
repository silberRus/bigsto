﻿
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбработатьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыбор();
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Закрыть();
	Иначе
		
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("УчетнаяЗапись", ТекущиеДанные.УчетнаяЗапись);
		СтруктураВозврата.Вставить("УдалятьПослеОтправки", ТекущиеДанные.УдалятьПослеОтправки);
		ОповеститьОВыборе(СтруктураВозврата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

