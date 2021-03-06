﻿&НаСервере
Процедура ЗагрузитьНаборы(текПользователь)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ОбъектУчета, Разрешено, Запрещено, Утверждает ИЗ РегистрСведений.НастройкиДоступаБюджетирование ГДЕ ОбъектУчета ССЫЛКА Справочник.СценарииПланирования И Пользователь = &Пользователь;
	|ВЫБРАТЬ ОбъектУчета, Разрешено, Запрещено, Утверждает ИЗ РегистрСведений.НастройкиДоступаБюджетирование ГДЕ ОбъектУчета ССЫЛКА Справочник.СтатьиБюджета И Пользователь = &Пользователь;
	|ВЫБРАТЬ ОбъектУчета, Разрешено, Запрещено, Утверждает ИЗ РегистрСведений.НастройкиДоступаБюджетирование ГДЕ ОбъектУчета ССЫЛКА Справочник.СтруктураПредприятия И Пользователь = &Пользователь;
	|ВЫБРАТЬ ОбъектУчета, Разрешено, Запрещено, Утверждает ИЗ РегистрСведений.НастройкиДоступаБюджетирование ГДЕ ОбъектУчета ССЫЛКА Справочник.МоделиБюджетов И Пользователь = &Пользователь;");
	
	Запрос.УстановитьПараметр("Пользователь", текПользователь);
	Пакет = Запрос.ВыполнитьПакет();
	
	Сценарии.Загрузить(Пакет[0].Выгрузить());
	СтатьиБюджета.Загрузить(Пакет[1].Выгрузить());
	Подразделения.Загрузить(Пакет[2].Выгрузить());
	МоделиБюджета.Загрузить(Пакет[3].Выгрузить());
	
	ОбновитьИтогиВЗаголовках();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНабор(Коллекция, Набор)
	
	Для Каждого Строка Из Коллекция Цикл
		
		НовСтрока = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
		НовСтрока.Пользователь = Пользователь;
		
	КонецЦикла;
	
КонецПроцедуры
&НаСервере
Процедура СохранитьНаСервере()
	
	Набор = РегистрыСведений.НастройкиДоступаБюджетирование.СоздатьНаборЗаписей();
	Набор.Отбор.Пользователь.Установить(Пользователь);
	
	ДобавитьНабор(Подразделения, 	Набор);
	ДобавитьНабор(СтатьиБюджета, 	Набор);
	ДобавитьНабор(Сценарии, 		Набор);
	ДобавитьНабор(МоделиБюджета, 	Набор);
	
	Набор.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиПриАктивизацииСтроки(Элемент)
	
	Пользователь = Элемент.ТекущаяСтрока;
	ЗагрузитьНаборы(Пользователь);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЦвета()
	
	// Оновляет список так чтобы цвет покраски поменялся после редактирования
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		Элементы.Пользователи.Обновить();
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ГруппыДоступа") Тогда
		Элементы.ГруппыДоступа.Обновить();
	КонецЕсли;
	
	ОбновитьИтогиВЗаголовках();
	
КонецПроцедуры
&НаСервереБезКонтекста
Функция ТекстЗаголовка(Имя, Количество)
	
	Возврат СтрШаблон("%1 %2", Имя, ?(Количество, "(" + Количество + ")", ""));
	
КонецФункции
&НаСервере
Процедура ОбновитьИтогиВЗаголовках()
	
	ЗаголовокПодразделение 	= ТекстЗаголовка("Подразделения", 	Подразделения.Количество());
	ЗаголовокСтатья 		= ТекстЗаголовка("Статьи", 			СтатьиБюджета.Количество());
	ЗаголовокСценарий 		= ТекстЗаголовка("Сценарии", 		Сценарии.Количество());
	ЗаголовокМодель 		= ТекстЗаголовка("Модели", 			МоделиБюджета.Количество());
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьВсехНажатие(Элемент)
	
	ОткрытьФорму("РегистрСведений.НастройкиДоступаБюджетирование.ФормаСписка");
	
КонецПроцедуры

#Область Заполнить_по_модели

&НаСервере
Процедура ЗаполнитьПоМоделиНаСервере(выбМодель)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ Таб.ОбъектУчета СтатьяБюджета ПОМЕСТИТЬ Отмеченные ИЗ &ТекСтатьи Таб;
	
	|ВЫБРАТЬ 	Спр.СтатьяБюджета ОбъектУчета, ИСТИНА Разрешено
	|ИЗ 		Справочник.МоделиБюджетов.Показатели Спр
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ	(ВЫБРАТЬ СтатьяБюджета ИЗ Отмеченные) КАК Таб
	|ПО					Таб.СтатьяБюджета = Спр.СтатьяБюджета
	|
	|ГДЕ Ссылка = &Ссылка И Таб.СтатьяБюджета ЕСТЬ NULL
	|");
	
	Запрос.УстановитьПараметр("Ссылка", 	выбМодель);
	Запрос.УстановитьПараметр("ТекСтатьи", 	СтатьиБюджета.Выгрузить(,"ОбъектУчета"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтатьиБюджета.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры
&НаКлиенте
Процедура ВыбранаМодельДляЗаполнения(выбМодель, ДопПараметры) Экспорт
	
	Если выбМодель <> Неопределено Тогда
		
		ЗаполнитьПоМоделиНаСервере(выбМодель);
		СохранитьНаСервере();
		ОбновитьЦвета();
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура ЗаполнитьПоМодели(Команда)
	
	ОткрытьФорму("Справочник.МоделиБюджетов.ФормаВыбора",,ЭтаФорма,,,,Новый ОписаниеОповещения("ВыбранаМодельДляЗаполнения", ЭтаФорма));
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НачалоВыбораОтбораНабораЗаписи(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекДанные = Элементы[Элемент.ТекстПодвала].ТекущиеДанные;
	
	Элемент.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка." + Сред(Элемент.Имя, 6));
	ТекДанные.ОбъектУчета 	= Элемент.ОграничениеТипа.ПривестиЗначение(ТекДанные.ОбъектУчета);
	Элемент.ВыбиратьТип 	= Ложь;
	
КонецПроцедуры
&НаКлиенте
Процедура ПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СохранитьНаСервере();
	ОбновитьЦвета();
	
КонецПроцедуры
&НаКлиенте
Процедура ПослеУдаления(Элемент)
	
	СохранитьНаСервере();
	ОбновитьЦвета();
	
КонецПроцедуры

&НаКлиенте
Процедура отчетНажатие(Элемент)
	
	ОткрытьФорму("Отчет.ПроверитьДоступКБюджетам.ФормаОбъекта",, ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьВсеФлаги(Действие)
	
	текЭлемент = ЭтаФорма.ТекущийЭлемент;
	Если 	ТипЗнч(текЭлемент) = Тип("ТаблицаФормы") И
			СтрНайти("МоделиБюджета, Подразделения, СтатьиБюджета, Сценарии", текЭлемент.Имя) Тогда
			
		ИмяТабл = текЭлемент.Имя;
		
		Если текЭлемент.ТекущийЭлемент <> Неопределено Тогда
		
			текКолонкаИмя 	= текЭлемент.ТекущийЭлемент.Имя;
			ИмяДействие 	= Сред(текКолонкаИмя, СтрДлина(ИмяТабл) + 1);
		
			Если СтрНайти("Утверждает, Разрешено, Запрещено", ИмяДействие) Тогда
				
				Для Каждого Строка Из ЭтаФорма[ИмяТабл] Цикл
					Строка[ИмяДействие] = Действие;
				КонецЦикла;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеФлаги(Команда)
	
	ИзменитьВсеФлаги(Ложь);
	
КонецПроцедуры
&НаКлиенте
Процедура ПрименитьВсеФлаги(Команда)
	
	ИзменитьВсеФлаги(Истина);
	
КонецПроцедуры
