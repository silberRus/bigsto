﻿
&НаСервере
Функция ПрочитатьГрафик()
	
	Запрос = Новый Запрос("ВЫБРАТЬ от, до, Работает ИЗ РегистрСведений.АТ_ГрафикРаботы ГДЕ Объект = &Объект УПОРЯДОЧИТЬ ПО Инд");
	Запрос.УстановитьПараметр("Объект", ОбъектГрафика);
	
	Менеджер 	= РегистрыСведений.АТ_ГрафикРаботы;
	Выборка 	= Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		новСтрока = График.Добавить();
		ЗаполнитьЗначенияСвойств(новСтрока, Выборка);
		новСтрока.отПредставление = РегистрыСведений.АТ_ГрафикРаботы.ПредставлениеДаты(новСтрока.от);
		новСтрока.доПредставление = РегистрыСведений.АТ_ГрафикРаботы.ПредставлениеДаты(новСтрока.до);
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
&НаСервере
Функция СохранитьГрафик()
	
	Рег = РегистрыСведений.АТ_ГрафикРаботы.СоздатьНаборЗаписей();
	Рег.Отбор.Объект.Установить(ОбъектГрафика);
	Рег.Загрузить(График.Выгрузить());
	
	КонвертацияТипов.ВыполнитьВыражениеВКаждойСтрокеТаблицы(Рег, "
											|Строка.Объект 	= Параметры;
											|Строка.Инд 	= Инд;
											|", ОбъектГрафика);
	Рег.Записать();
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбъектГрафика = Параметры.ОбъектГрафика;
	ПрочитатьГрафик();
	
КонецПроцедуры

&НаКлиенте
Процедура Установить(Команда)
	
	Если СохранитьГрафик() Тогда
		ПоказатьОповещениеПользователя("Обновлен график работы",,ОбъектГрафика,БиблиотекаКартинок.Календарь);
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикОтПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("РегистрСведений.АТ_ГрафикРаботы.Форма.ВыборПериода", Новый Структура("ДатаКалендаря", Элементы.График.ТекущиеДанные.От), ЭтаФорма,,,,Новый ОписаниеОповещения("ВыбранПериод",ЭтаФорма, "От"));
	
КонецПроцедуры
&НаКлиенте
Процедура ГрафикДоПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("РегистрСведений.АТ_ГрафикРаботы.Форма.ВыборПериода", Новый Структура("ДатаКалендаря", Элементы.График.ТекущиеДанные.До), ЭтаФорма,,,,Новый ОписаниеОповещения("ВыбранПериод",ЭтаФорма, "До"));
	
КонецПроцедуры
Процедура ВыбранПериод(ДатаИПредставление, ИмяКолонки) Экспорт
	
	Если ДатаИПредставление <> Неопределено Тогда
		
		Строка = График.НайтиПоИдентификатору(Элементы.График.ТекущаяСтрока);
		
		Строка[ИмяКолонки] 						= ДатаИПредставление.ДатаКалендаря;
		Строка[ИмяКолонки + "Представление"] 	= ДатаИПредставление.Представление;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуНеделю(СтруктураДаты, Неделя, от, до)
	
	НовСтрока = График.Добавить();
	СтруктураДаты.Неделя = Неделя;
	
	СтруктураДаты.Время = от;
	Структура = РегистрыСведений.АТ_ГрафикРаботы.ПолучитьСтрокуИПредставление(СтруктураДаты);
	НовСтрока.от				= Структура.Строка;
	НовСтрока.отПредставление 	= Структура.Представление;
	
	СтруктураДаты.Время = до;
	Структура = РегистрыСведений.АТ_ГрафикРаботы.ПолучитьСтрокуИПредставление(СтруктураДаты);
	НовСтрока.до				= Структура.Строка;
	НовСтрока.доПредставление 	= Структура.Представление;
	
	НовСтрока.Работает = Истина;
	
КонецПроцедуры
&НаСервере
Процедура ЗаполнитьРабочииДни(от, до, КолДней)
	
	СтруктураДаты = РегистрыСведений.АТ_ГрафикРаботы.ПолучитьСтруктуруДаты("Z0000000");
	
	Для Ном = 1 По КолДней Цикл
		ДобавитьСтрокуНеделю(СтруктураДаты, Строка(Ном), от, до);
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ВыбранаДата(ВыбДата, ДопПараметры) Экспорт
	
	Если ВыбДата <> Неопределено ТОгда
		
		Если СтрНачинаетсяС(ДопПараметры, "от") Тогда
			ПоказатьВводДаты(Новый ОписаниеОповещения("ВыбранаДата", ЭтаФорма, Новый Структура("от,КолДней", ВыбДата, Число(Прав(ДопПараметры, 1)))),,"Окончание работы", ЧастиДаты.Время);
		Иначе
			ЗаполнитьРабочииДни(ДопПараметры.От, ВыбДата, ДопПараметры.КолДней);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура РабочииДни(Команда)
	
	ПоказатьВводДаты(Новый ОписаниеОповещения("ВыбранаДата", ЭтаФорма, "от5"),,"Начало работы", ЧастиДаты.Время);
	
КонецПроцедуры
&НаКлиенте
Процедура РабочииДни1(Команда)
	
	ПоказатьВводДаты(Новый ОписаниеОповещения("ВыбранаДата", ЭтаФорма, "от6"),,"Начало работы", ЧастиДаты.Время);
	
КонецПроцедуры
