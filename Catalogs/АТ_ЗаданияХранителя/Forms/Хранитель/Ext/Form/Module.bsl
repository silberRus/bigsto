﻿
&НаСервере
Процедура ОбновитьТекстПроцедуры(Ссылка)
	
	ТекстПроцедур.УстановитьТекст(Ссылка.ВыполняемыйКод);
	
КонецПроцедуры
&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	текСсылка = Элементы.Список.ТекущаяСтрока;
	Если текСсылка <> Неопределено Тогда
		
		ОбновитьТекстПроцедуры(текСсылка);
		
	КонецЕсли;
	
КонецПроцедуры
