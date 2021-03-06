﻿
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		Объект["Наименование"],
		Объект["АдресЗначенияПолей"]);
КонецПроцедуры


&НаКлиенте
Процедура НаименованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоставкаТоваровКлиент.ОткрытьФормуВыбораАдресаИОбработатьРезультат(
	    Элемент,
		Объект["Наименование"],
		Объект["АдресЗначенияПолей"],
		СтандартнаяОбработка);

КонецПроцедуры


&НаКлиенте
Процедура НаименованиеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НаименованиеПриИзменении(Элемент);
	
	ДоставкаТоваровКлиент.АдресДоставкиОбработкаВыбора(Элементы, Объект, Элемент.Имя, ВыбранноеЗначение);
	
	Модифицированность = Истина;

КонецПроцедуры

