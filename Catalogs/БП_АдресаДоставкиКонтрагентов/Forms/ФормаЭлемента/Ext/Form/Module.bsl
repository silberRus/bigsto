﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Параметры.Свойство("Партнер") Тогда
			Объект.Партнер = Параметры.Партнер;
			Элементы.Партнер.ТолькоПросмотр = Истина;
		КонецЕсли;
		Если Параметры.Свойство("Контрагент") Тогда
			Объект.Контрагент = Параметры.Контрагент;
			Объект.Партнер = Объект.Контрагент.Партнер;
			Элементы.Партнер.ТолькоПросмотр = Истина;
			Элементы.Контрагент.ТолькоПросмотр = Истина;
		КонецЕсли;
		Если Параметры.Свойство("Склад") Тогда
			Объект.Склад = Параметры.Склад;
			Элементы.Склад.ТолькоПросмотр = Истина;
			Элементы.Партнер.ТолькоПросмотр = Истина;
			Элементы.Контрагент.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ДополнительныеПараметрыКИ = УправлениеКонтактнойИнформацией.ПараметрыКонтактнойИнформацией();
	ДополнительныеПараметрыКИ.Вставить("ИмяЭлементаДляРазмещения", "ГруппаКонтактнаяИнформация");
	ДополнительныеПараметрыКИ.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Справочники.Партнеры.НеизвестныйПартнер, ДополнительныеПараметрыКИ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьСписокВыбораКонтактныхЛиц();	
	нвСтрока = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
	нвСтрока.Вид = ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента");
	нвСтрока.ДействуетС = Дата(1,1,1);
	нвСтрока.ЗначенияПолей = Объект.ЗначенияПолей;
	нвСтрока.ИмяРеквизита = "АдресДоставки";
	нвСтрока.ИмяЭлементаДляРазмещения = "ГруппаКонтактнаяИнформация";
	нвСтрока.ДействуетС = Дата(1,1,1);
	нвСтрока.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес");
	АдресДоставки = Объект.Представление;
	
	// silber { Добавим график работы на форму
	РегистрыСведений.АТ_ГрафикРаботы.ДобавитьЭлементыГрафикаРаботы(ЭтаФорма);
	// } silber
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКонтактныхЛиц()

	Элементы.КонтактноеЛицо.СписокВыбора.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактныеЛицаПартнеров.Контрагент,
		|	КонтактныеЛицаПартнеров.Ссылка
		|ИЗ
		|	Справочник.КонтактныеЛицаПартнеров КАК КонтактныеЛицаПартнеров
		|ГДЕ
		|	КонтактныеЛицаПартнеров.Владелец = &Владелец
		|	И (КонтактныеЛицаПартнеров.Контрагент = &Контрагент
		|	ИЛИ КонтактныеЛицаПартнеров.Контрагент = &ПустойКонтрагент)";
	
	Запрос.УстановитьПараметр("Владелец", Объект.Партнер);
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Элементы.КонтактноеЛицо.СписокВыбора.Добавить(ВыборкаДетальныеЗаписи.Ссылка,Строка(ВыборкаДетальныеЗаписи.Ссылка) +" ("+Строка(ВыборкаДетальныеЗаписи.Контрагент)+")");	
	КонецЦикла;
	

КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииНаСервере()
	Если ЗначениеЗаполнено(Объект.КонтактноеЛицо.Контрагент) И Объект.КонтактноеЛицо.Контрагент <> Объект.Контрагент Тогда
		Объект.КонтактноеЛицо = "";
	КонецЕсли;
	ЗаполнитьСписокВыбораКонтактныхЛиц();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	Подключаемый_ОбновитьКонтактнуюИнформацию("");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат) 	Экспорт
	текСтрока = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Получить(0);
	Объект.Тип = текСтрока.Тип;
	Объект.Вид = текСтрока.Вид;
	Объект.Представление = АдресДоставки;
	Объект.Наименование = АдресДоставки+" ("+Строка(Объект.КонтактноеЛицо)+")";
	Объект.ЗначенияПолей = текСтрока.ЗначенияПолей;
	ОбновитьРегионГород();
	УправлениеКонтактнойИнформациейКлиентСервер.ПреобразоватьСтрокуВСписокПолей(Объект.ЗначенияПолей);
КонецПроцедуры

&НаСервере
Процедура ОбновитьРегионГород()
	
	Объект.Город = УправлениеКонтактнойИнформацией.ГородАдресаКонтактнойИнформации(Объект.ЗначенияПолей);
	Объект.Регион = УправлениеКонтактнойИнформацией.РегионАдресаКонтактнойИнформации(Объект.ЗначенияПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	КонтрагентПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НЕ ЗначениеЗаполнено(Объект.Представление) Тогда
		СообщениеПоользователю = Новый СообщениеПользователю();
		СообщениеПоользователю.Поле = "АдресДоставки";
		СообщениеПоользователю.Текст = "Не заполнен адрес доставки";
		СообщениеПоользователю.Сообщить();
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Записать();
	Закрыть(Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВФорме(Команда)
	Записать();
КонецПроцедуры

// silber {

#Область график

&НаКлиенте
Процедура ГрафикРаботыНажатие(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму("РегистрСведений.АТ_ГрафикРаботы.Форма.РедактированиеГрафикаОбъекта", 
			Новый Структура("ОбъектГрафика", Объект.Ссылка), ЭтаФорма,,,,Новый ОписаниеОповещения("ЗакрытДиалогРасписания", ЭтаФорма));
	
КонецПроцедуры
&НаКлиенте
Процедура ЗакрытДиалогРасписания(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		ОбновитьИнформацюПоГрафику();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформацюПоГрафику() Экспорт
	
	РегистрыСведений.АТ_ГрафикРаботы.ОбновитьИнформацюПоГрафику(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

// } silber
