﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПериодАнализа.ДатаНачала = Объект.ДатаАнализаНачало;
	ПериодАнализа.ДатаОкончания = Объект.ДатаАнализаКонец;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланПродажПоБрендамСрезПоследних.Партнер,
		|	ПланПродажПоБрендамСрезПоследних.ГруппаНоменклатуры
		|ИЗ
		|	РегистрСведений.ПланПродажПоБрендам.СрезПоследних(
		|			&Период,
		|			Менеджер = &ОтветственныйМенеджер
		|				И ПланПродаж = &ПланПродаж) КАК ПланПродажПоБрендамСрезПоследних
		|ГДЕ
		|	ПланПродажПоБрендамСрезПоследних.Сумма > 0";
		Запрос.УстановитьПараметр("ОтветственныйМенеджер", Объект.ОтветственныйМенеджер);
		Запрос.УстановитьПараметр("ПланПродаж", Объект.Ссылка);
		Запрос.УстановитьПараметр("Период", Объект.ПериодПланирования);
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			ЗаполнитьНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ДатаАнализаНачало = ПериодАнализа.ДатаНачала;
	ТекущийОбъект.ДатаАнализаКонец = ПериодАнализа.ДатаОкончания;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменитьВидимостьЭлементаГруппаДобавитьВПлан();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДокументРезультатПриИзменении(Элемент)
	
	Строка = Элемент.ТекущаяОбласть.Верх;
	Колонка = Элемент.ТекущаяОбласть.Лево;
	
	Если ЗначениеЗаполнено(Элемент.ТекущаяОбласть.Лево) И Элемент.ТекущаяОбласть.СодержитЗначение = Истина Тогда
		
		ТекущееЗначение = Элемент.ТекущаяОбласть.Значение;
		МассивСтрок = СвязиВОтчете.НайтиСтроки(Новый Структура("Ряд", Строка));
		
		Если МассивСтрок.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		РедактируемаяСтрока = МассивСтрок[0];
		
		мСвязи = СвязиВОтчете.НайтиСтроки(Новый Структура("Партнер", РедактируемаяСтрока.Партнер));
		НомерСтрокиМаксимум = 0;
		НомерСтрокиМинимум = 0;
		НомерСтрокиГруппы = 0;
		
		Для Каждого ЭлементСвязи Из мСвязи Цикл
			Если НомерСтрокиМаксимум < ЭлементСвязи.Ряд Тогда
				НомерСтрокиМаксимум = ЭлементСвязи.Ряд;
			КонецЕсли;
			Если НомерСтрокиМинимум = 0 Или НомерСтрокиМинимум > ЭлементСвязи.Ряд Тогда
				НомерСтрокиМинимум = ЭлементСвязи.Ряд;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлементСвязи.ГруппаНоменклатуры) И Не ЗначениеЗаполнено(ЭлементСвязи.Производитель) Тогда
				НомерСтрокиГруппы = ЭлементСвязи.Ряд;
			КонецЕсли;
		КонецЦикла;
		
		СтруктураСвязи = Новый Структура(
			"Партнер, ГруппаНоменклатуры, Производитель, УровеньГруппировки",
			РедактируемаяСтрока.Партнер, РедактируемаяСтрока.ГруппаНоменклатуры, РедактируемаяСтрока.Производитель, РедактируемаяСтрока.УровеньГруппировки);
		
		ЗавершитьРедактированиеЯчейки(СтруктураСвязи, ТекущееЗначение, Строка, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументРезультатПриАктивизацииОбласти(Элемент)
	Если ЗначениеЗаполнено(Элемент.ТекущаяОбласть.Лево) Тогда
		Если Элемент.ТекущаяОбласть.Лево = 1 Тогда
			РасшифровкаПоСвязям = СвязиВОтчете.НайтиСтроки(Новый Структура("Ряд", Элемент.ТекущаяОбласть.Верх));
			Для Каждого Элемент Из РасшифровкаПоСвязям Цикл
				Если ЗначениеЗаполнено(Элемент.Производитель) Тогда
					ПроизводительДобавить = Элемент.Производитель;
				ИначеЕсли ЗначениеЗаполнено(Элемент.ГруппаНоменклатуры) Тогда
					ГруппаНоменклатурыДобавить = Элемент.ГруппаНоменклатуры;
				ИначеЕсли ЗначениеЗаполнено(Элемент.Партнер) Тогда
					ПартнерДобавить = Элемент.Партнер;
				КонецЕсли;
			КонецЦикла;
		ИначеЕсли Элемент.ТекущаяОбласть.Лево = ДокументРезультат.ШиринаТаблицы Тогда
			Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
				ПоказатьПредупреждение(, "Для редактирования плана требуется записать документ!");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДокументРезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	Перем ВыполненноеДействие, ПараметрВыполненногоДействия;

	СтандартнаяОбработка = Ложь;
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(АдресРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));

	//ОбработкаРасшифровки.ВыбратьДействие(Расшифровка, ВыполненноеДействие, ПараметрВыполненногоДействия, ДоступныеДействия);
	

	//ОткрытьЗначение(ПараметрВыполненногоДействия);
	
	ДоступныеДействия=Новый Массив;
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	//Дополнительные действия - свои пункты меню, которые будут доступны по двойному щелчку
	
	ДополнительныеДействия = Новый СписокЗначений;
	//ДополнительныеДействия.Добавить("РасшифровкаПоДокументам", "Расшифровка по документам");
	//ДополнительныеДействия.Добавить("РасшифровкаПоРегистратору", "Расшифровка по регистратору");
	
	Оп = Новый ОписаниеОповещения("РезультатОбработкаРасшифровки_Продолжение", ЭтаФорма, Расшифровка);
	ОбработкаРасшифровки.ПоказатьВыборДействия(Оп, Расшифровка, ДоступныеДействия, ДополнительныеДействия, Ложь);
	//СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки_Продолжение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
	//Если ВыполненноеДействие = "РасшифровкаПоДокументам" Тогда
	//    РасшифровкаПоДокументам(ДополнительныеПараметры);
	//ИначеЕсли ВыполненноеДействие = "РасшифровкаПоРегистратору" Тогда
	//    РасшифровкаПоРегистратору(ДополнительныеПараметры);
	//ИначеЕсли ВыполненноеДействие=ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
	//    ОткрытьЗначение(ПараметрВыполненногоДействия);
	//КонецЕсли;    
КонецПроцедуры

&НаКлиенте
Процедура ПериодПланированияПриИзменении(Элемент)
	
	Объект.ПериодПланирования = НачалоМесяца(Объект.ПериодПланирования);
	ЕстьДокумент = ПорверитьСуществующиеДокументы();
	
	Если ЕстьДокумент Тогда
		Объект.ПериодПланирования = ПолучитьПустоеЗначениеРеквизита(Объект.ПериодПланирования);
		ПоказатьПредупреждение(, "В базе уже есть такой документ планирования!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйМенеджерПриИзменении(Элемент)
	
	ЕстьДокумент = ПорверитьСуществующиеДокументы();
	
	Если ЕстьДокумент Тогда
		Объект.ОтветственныйМенеджер = ПолучитьПустоеЗначениеРеквизита(Объект.ОтветственныйМенеджер);
		ПоказатьПредупреждение(, "В базе уже есть такой документ планирования!");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПорверитьСуществующиеДокументы()
	
	Если ЗначениеЗаполнено(Объект.ОтветственныйМенеджер) И ЗначениеЗаполнено(Объект.ПериодПланирования) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланПродажПоБрендам.Ссылка
		|ИЗ
		|	Документ.ПланПродажПоБрендам КАК ПланПродажПоБрендам
		|ГДЕ
		|	ПланПродажПоБрендам.ОтветственныйМенеджер = &ОтветственныйМенеджер
		|	И ПланПродажПоБрендам.ПериодПланирования = &ПериодПланирования
		|	И (&СсылкиНеСуществует ИЛИ ПланПродажПоБрендам.Ссылка <> &Ссылка)";
		Запрос.УстановитьПараметр("ОтветственныйМенеджер", Объект.ОтветственныйМенеджер);
		Запрос.УстановитьПараметр("ПериодПланирования", Объект.ПериодПланирования);
		Запрос.УстановитьПараметр("СсылкиНеСуществует", Не ЗначениеЗаполнено(Объект.Ссылка));
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		
		Если Не Запрос.Выполнить().Пустой() Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти


#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Заполнить(Команда)
	
	ТекстПредупреждения = "";
	
	Если Не ЗначениеЗаполнено(Объект.ОтветственныйМенеджер) Тогда
		ТекстПредупреждения = "Не выбран ответственный менеджер!";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ПериодПланирования) Тогда
		ТекстПредупреждения = "Не выбран период планирования!";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПериодАнализа.ДатаНачала) Или Не ЗначениеЗаполнено(ПериодАнализа.ДатаОкончания) Тогда
		ТекстПредупреждения = "Не выбран период анализа данных!";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
	Иначе
		ЗаполнитьНаСервере();
		ИзменитьВидимостьЭлементаГруппаДобавитьВПлан();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Об = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = Об.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаАнализаНачала", ПериодАнализа.ДатаНачала);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ДатаАнализаОкончания", ПериодАнализа.ДатаОкончания);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОтветственныйМенеджер", Объект.ОтветственныйМенеджер);
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ПериодПланирования", НачалоМесяца(Объект.ПериодПланирования));
	
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;

	ДокументРезультат.Очистить();
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДокументРезультат.ПоказатьУровеньГруппировокСтрок(0);
	
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	АдресРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	
	//Адрес = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	//ДанныеРасшифровки = Адрес;
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	ДокументРезультат.УдалитьОбласть(ДокументРезультат.Область(ДокументРезультат.ФиксацияСверху + 1, , ДокументРезультат.ФиксацияСверху + 3), ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	ЗаполнитьСвязьВОтчете(СхемаКомпоновкиДанных, ДанныеРасшифровки, Истина);
	
	ДанныеРасшифровки = АдресРасшифровки;
	
	ТаблицаСвязиВОтчете = СвязиВОтчете.Выгрузить();
	ТаблицаСвязиВОтчете.Свернуть("Партнер");
	Количество = ТаблицаСвязиВОтчете.Количество() - 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВПлан(Команда)
	
	Предупреждение = ДобавитьВПланНаСервере();
	
	Если ЗначениеЗаполнено(Предупреждение) Тогда
		ПоказатьПредупреждение( , Предупреждение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьВПланНаСервере()
	
	//Проверки.
	ПохожиеСтроки = СвязиВОтчете.НайтиСтроки(Новый Структура("Партнер, ГруппаНоменклатуры, Производитель", ПартнерДобавить, ГруппаНоменклатурыДобавить, ПроизводительДобавить));
	Если ПохожиеСтроки.Количество() > 0 Тогда
		Возврат "В плане продаж уже есть такая строка.";
	КонецЕсли;
	
	Если ПартнерДобавить.ОсновнойМенеджер <> Объект.ОтветственныйМенеджер Тогда
		Возврат "Основной менеджер партнера не соответствует текущему менеджеру!";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ГруппаНоменклатурыДобавить.Родитель) Тогда
		Возврат "Выберите группу нижнего уровня!";
	КонецЕсли;
	
	//Принятие решения.
	СтруктураСвязи = Новый Структура(
			"Партнер, ГруппаНоменклатуры, Производитель, УровеньГруппировки",
			ПартнерДобавить, ГруппаНоменклатурыДобавить, ПроизводительДобавить, 0);
	
	мСвязи = СвязиВОтчете.НайтиСтроки(Новый Структура("Партнер", ПартнерДобавить));
	
	ДобавлениеПроизводителя = Ложь;
	ДобавлениеГруппыНоменклатуры = Ложь;
	ДобавлениеПартнера = Ложь;
	
	Если мСвязи.Количество() > 0 Тогда
		
		НомерСтрокиМаксимум = 0;
		НомерСтрокиМинимум = 0;
		НомерСтрокиМинимумВГруппе = 0;
		НомерСтрокиМаксимумВГруппе = 0;
		НомерСтроки = 0;
		НомерСтрокиГруппы = 0;
		
		Для Каждого ЭлементСвязи Из мСвязи Цикл
			Если ГруппаНоменклатурыДобавить = ЭлементСвязи.ГруппаНоменклатуры Тогда
				//Новый производитель.
				ДобавлениеПроизводителя = Истина;
				НомерСтроки = ЭлементСвязи.Ряд;
				Если НомерСтрокиМинимумВГруппе = 0 Или НомерСтрокиМинимумВГруппе > ЭлементСвязи.Ряд Тогда
					НомерСтрокиМинимумВГруппе = ЭлементСвязи.Ряд;
				КонецЕсли;
				Если НомерСтрокиМаксимумВГруппе < ЭлементСвязи.Ряд Тогда
					НомерСтрокиМаксимумВГруппе = ЭлементСвязи.Ряд;
				КонецЕсли;
			КонецЕсли;
			Если НомерСтрокиМаксимум < ЭлементСвязи.Ряд Тогда
				НомерСтрокиМаксимум = ЭлементСвязи.Ряд;
			КонецЕсли;
			Если НомерСтрокиМинимум = 0 Или НомерСтрокиМинимум > ЭлементСвязи.Ряд Тогда
				НомерСтрокиМинимум = ЭлементСвязи.Ряд;
			КонецЕсли;
			Если ЗначениеЗаполнено(ЭлементСвязи.ГруппаНоменклатуры) И Не ЗначениеЗаполнено(ЭлементСвязи.Производитель) Тогда
				НомерСтрокиГруппы = ЭлементСвязи.Ряд;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ДобавлениеПроизводителя Тогда
			//Новая группа номенклатуры.
			ДобавлениеГруппыНоменклатуры = Истина;
		КонецЕсли;
		
	Иначе
		//Новый партнер.
		ДобавлениеПартнера = Истина;
	КонецЕсли;
	
	//Непосредственное добавление.
	Если ДобавлениеПроизводителя Тогда
		
		ДокументРезультат.ВставитьОбласть(
			ДокументРезультат.Область(НомерСтроки, , НомерСтроки),
			,
			ТипСмещенияТабличногоДокумента.ПоВертикали);
			
		ДокументРезультат.Область(НомерСтрокиМинимумВГруппе + 1, , НомерСтрокиМаксимумВГруппе).Разгруппировать();
		ДокументРезультат.Область(НомерСтрокиМинимумВГруппе + 1, , НомерСтрокиМаксимумВГруппе + 1).Сгруппировать();
		
		ИзменитьСкопированнуюОбласть(НомерСтроки + 1, ПроизводительДобавить, Сумма);
		
		Для Каждого Строка Из СвязиВОтчете Цикл
			Если Строка.Ряд > НомерСтроки Тогда
				Строка.Ряд = Строка.Ряд + 1;
			КонецЕсли;
		КонецЦикла;
		
		ДобавитьСвязьВОтчет(НомерСтроки + 1, СтруктураСвязи, 3);
		
		Если Сумма <> 0 Тогда
			СтруктураСвязи.УровеньГруппировки = 3;
			ЗавершитьРедактированиеЯчейки(СтруктураСвязи, Сумма, НомерСтроки + 1, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум);
		КонецЕсли;
		
	ИначеЕсли ДобавлениеГруппыНоменклатуры Тогда
		
		ДокументРезультат.ВставитьОбласть(
			ДокументРезультат.Область(НомерСтрокиМаксимум, , НомерСтрокиМаксимум),
			,
			ТипСмещенияТабличногоДокумента.ПоВертикали);
			
		ДокументРезультат.ВставитьОбласть(
			ДокументРезультат.Область(НомерСтрокиГруппы, , НомерСтрокиГруппы),
			ДокументРезультат.Область(НомерСтрокиМаксимум + 1, , НомерСтрокиМаксимум + 1),
			ТипСмещенияТабличногоДокумента.ПоВертикали);
			
		ДокументРезультат.Область(НомерСтрокиМаксимум + 2, , НомерСтрокиМаксимум + 2).Сгруппировать();
		ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМаксимум).Разгруппировать();
		ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМаксимум + 2).Сгруппировать();
		
		ИзменитьСкопированнуюОбласть(НомерСтрокиМаксимум + 1, ГруппаНоменклатурыДобавить, 0);
		ИзменитьСкопированнуюОбласть(НомерСтрокиМаксимум + 2, ПроизводительДобавить, Сумма);
		
		Для Каждого Строка Из СвязиВОтчете Цикл
			Если Строка.Ряд > НомерСтрокиМаксимум Тогда
				Строка.Ряд = Строка.Ряд + 2;
			КонецЕсли;
		КонецЦикла;
		
		ДобавитьСвязьВОтчет(НомерСтрокиМаксимум + 1, Новый Структура("Партнер, ГруппаНоменклатуры, Производитель", ПартнерДобавить, ГруппаНоменклатурыДобавить, ПроизводительПустая), 2);
		ДобавитьСвязьВОтчет(НомерСтрокиМаксимум + 2, СтруктураСвязи, 3);
		
		Если Сумма <> 0 Тогда
			СтруктураСвязи.УровеньГруппировки = 3;
			ЗавершитьРедактированиеЯчейки(СтруктураСвязи, Сумма, НомерСтрокиМаксимум + 2, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум);
		КонецЕсли;
		
	ИначеЕсли ДобавлениеПартнера Тогда
		
		Если СвязиВОтчете.Количество() = 0 Тогда
			Возврат "Требуется сформировать таблицу.";
		КонецЕсли;
		
		НомерСтрокиМаксимум = ДокументРезультат.ВысотаТаблицы - 1;
		НомерСтрокиМинимум = СвязиВОтчете[0].Ряд;
		
		ВидимостьОбласти = ДокументРезультат.Область(НомерСтрокиМинимум + 1, ,НомерСтрокиМинимум + 2).Видимость;
		ДокументРезультат.Область(НомерСтрокиМинимум + 1, ,НомерСтрокиМинимум + 2).Видимость = Истина;
		
		ДокументРезультат.ВставитьОбласть(
			ДокументРезультат.Область(НомерСтрокиМинимум, ,НомерСтрокиМинимум + 2),
			ДокументРезультат.Область(НомерСтрокиМинимум, ,НомерСтрокиМинимум + 2),
			ТипСмещенияТабличногоДокумента.ПоВертикали);
		
		ДокументРезультат.Область(НомерСтрокиМинимум + 4, ,НомерСтрокиМинимум + 5).Видимость = ВидимостьОбласти;
		
		ДокументРезультат.Область(НомерСтрокиМинимум + 2, , НомерСтрокиМинимум + 2).Сгруппировать();
		ДокументРезультат.Область(НомерСтрокиМинимум + 2, , НомерСтрокиМинимум + 1).Сгруппировать();
		
		ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум, ПартнерДобавить, 0);
		ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум + 1, ГруппаНоменклатурыДобавить, 0);
		ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум + 2, ПроизводительДобавить, Сумма);
		
		Для Каждого Строка Из СвязиВОтчете Цикл
			Строка.Ряд = Строка.Ряд + 3;
		КонецЦикла;
		
		ДобавитьСвязьВОтчет(НомерСтрокиМинимум, Новый Структура("Партнер, ГруппаНоменклатуры, Производитель", ПартнерДобавить, ГруппаНоменклатурыПустая, ПроизводительПустая), 1);
		ДобавитьСвязьВОтчет(НомерСтрокиМинимум + 1, Новый Структура("Партнер, ГруппаНоменклатуры, Производитель", ПартнерДобавить, ГруппаНоменклатурыДобавить, ПроизводительПустая), 2);
		ДобавитьСвязьВОтчет(НомерСтрокиМинимум + 2, СтруктураСвязи, 3);
		
		Если Сумма <> 0 Тогда
			СтруктураСвязи.УровеньГруппировки = 3;
			ЗавершитьРедактированиеЯчейки(СтруктураСвязи, Сумма, НомерСтрокиМинимум + 2, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура ИзменитьСкопированнуюОбласть(НомерСтроки, ТекстГруппировки, Сумма)
	
	РедактируемаяОбласть = ДокументРезультат.Область(НомерСтроки, 1, НомерСтроки, 1);
	РедактируемаяОбласть.Текст = ТекстГруппировки;
		
	Для Итератор = 2 По ДокументРезультат.ШиринаТаблицы - 1 Цикл
		РедактируемаяОбласть = ДокументРезультат.Область(НомерСтроки, Итератор, НомерСтроки, Итератор);
		РедактируемаяОбласть.Текст = "";
	КонецЦикла;
	
	РедактируемаяОбласть = ДокументРезультат.Область(НомерСтроки, ДокументРезультат.ШиринаТаблицы, НомерСтроки, ДокументРезультат.ШиринаТаблицы);
	РедактируемаяОбласть.Значение = Сумма;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСвязьВОтчет(НомерСтроки, СтруктураСвязи, УровеньГруппировки)
	
	НоваяСвязь = СвязиВОтчете.Добавить();
	НоваяСвязь.Ряд = НомерСтроки;
	НоваяСвязь.Колонка = ДокументРезультат.ШиринаТаблицы;
	НоваяСвязь.Партнер = СтруктураСвязи.Партнер;
	НоваяСвязь.ГруппаНоменклатуры = СтруктураСвязи.ГруппаНоменклатуры;
	НоваяСвязь.Производитель = СтруктураСвязи.Производитель;
	НоваяСвязь.ИдентификаторРасшифровки = 0;
	НоваяСвязь.УровеньГруппировки = УровеньГруппировки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСвязьВОтчете(СхемаКомпоновкиДанных, ДанныеРасшифровки, ПриСоздании = Ложь)
	
	КЧ = Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Неотрицательный);
	ОписаниеТиповЧисло = Новый ОписаниеТипов("Число",,,КЧ);
	
	ТекущийПартнер = Справочники.Партнеры.ПустаяСсылка();
	УровеньГруппировки = 0;
	
	Для Ряд = ДокументРезультат.ФиксацияСверху + 1 По ДокументРезультат.ВысотаТаблицы цикл
		
		ТекущаяОбласть = ДокументРезультат.Область(Ряд, ДокументРезультат.ШиринаТаблицы, Ряд, ДокументРезультат.ШиринаТаблицы);
		
		Если ТекущаяОбласть.Расшифровка = Неопределено Тогда Продолжить; КонецЕсли;
		
		ЗначенияРасшифровки = ПолучитьВсеЗначенияРасшифровки(ДанныеРасшифровки.Элементы[ТекущаяОбласть.Расшифровка]);
		ЗначенияГруппировок = ПолучитьЗначенияГруппировокОтчета(ДанныеРасшифровки, ТекущаяОбласть.Расшифровка, "Период", Новый Структура("Партнер, ГруппаНоменклатуры, Производитель, Период"), СхемаКомпоновкиДанных);
		
		Если ЗначенияРасшифровки.Свойство("Сумма") И ЗначенияГруппировок.Свойство("Период") И ЗначенияГруппировок.Период = "План продаж" Тогда
			
			НоваяСвязь = СвязиВОтчете.Добавить();
			НоваяСвязь.Ряд = Ряд;
			НоваяСвязь.Колонка = ДокументРезультат.ШиринаТаблицы;
			НоваяСвязь.Партнер = ЗначенияГруппировок.Партнер;
			НоваяСвязь.ГруппаНоменклатуры = ЗначенияГруппировок.ГруппаНоменклатуры;
			НоваяСвязь.Производитель = ЗначенияГруппировок.Производитель;
			НоваяСвязь.ИдентификаторРасшифровки = ТекущаяОбласть.Расшифровка;
			
			Если УровеньГруппировки = 0 Тогда
				УровеньГруппировки = 1;
				ТекущийПартнер = ЗначенияГруппировок.Партнер;
			ИначеЕсли УровеньГруппировки = 1 Тогда
				УровеньГруппировки = 2;
			ИначеЕсли УровеньГруппировки = 2 Тогда
				УровеньГруппировки = 3;
			ИначеЕсли ЗначениеЗаполнено(ЗначенияГруппировок.Производитель) Тогда
				УровеньГруппировки = 3;
			ИначеЕсли ЗначенияГруппировок.Партнер <> ТекущийПартнер Тогда
				УровеньГруппировки = 1;
				ТекущийПартнер = ЗначенияГруппировок.Партнер;
			ИначеЕсли УровеньГруппировки = 3 Тогда
				УровеньГруппировки = 2;
			КонецЕсли;
			
			НоваяСвязь.УровеньГруппировки = УровеньГруппировки;
			
			Если ПриСоздании Тогда 
				Значение = ?(ЗначениеЗаполнено(ТекущаяОбласть.Текст), Число(ТекущаяОбласть.Текст), 0);
				ТекущаяОбласть.СодержитЗначение = Истина;
				ТекущаяОбласть.ТипЗначения = ОписаниеТиповЧисло;
				ТекущаяОбласть.Значение = Значение;
				
				Если УровеньГруппировки = 3 Тогда
					ТекущаяОбласть.ЦветФона = WebЦвета.ЦианСветлый;
					ТекущаяОбласть.Защита = Ложь;
				ИначеЕсли Не ЗначениеЗаполнено(ЗначенияГруппировок.Производитель) И Не ЗначениеЗаполнено(ЗначенияГруппировок.ГруппаНоменклатуры) И УровеньГруппировки = 1 Тогда
					ТекущаяОбласть.ЦветФона = WebЦвета.БледноБирюзовый;
					ТекущаяОбласть.Защита = Ложь;
				КонецЕсли;
			КонецЕсли;
		Иначе
			
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВсеЗначенияРасшифровки(Данные)

	ЗначенияРасшифровки = Новый Структура;
	
	спПоля = Данные.ПолучитьПоля();
	Для Каждого текПоле Из спПоля Цикл
		ЗначенияРасшифровки.Вставить(СтрЗаменить(текПоле.Поле, ".", "_"), текПоле.Значение);
	КонецЦикла;
	
	Возврат ЗначенияРасшифровки;
КонецФункции

&НаСервере
Функция ПолучитьЗначенияГруппировокОтчета(Знач ДанныеРасшифровки, Расшифровка, ПолеРасшифровки, ЗначенияГруппировок, СхемаКомпоновкиДанных)
	
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	РезультатРасшифровки = ОбработкаРасшифровки.Расшифровать(Расшифровка, Новый полеКомпоновкиДанных(ПолеРасшифровки));
	
	Для Каждого текСтрокаОтбора Из РезультатРасшифровки.Отбор.Элементы Цикл
		Для Каждого текГруппировка Из ЗначенияГруппировок Цикл
			Если текСтрокаОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(текГруппировка.Ключ) и текСтрокаОтбора.Использование=Истина Тогда
				ЗначенияГруппировок[текГруппировка.Ключ] = текСтрокаОтбора.ПравоеЗначение;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ЗначенияГруппировок;
КонецФункции

&НаСервере
Процедура ЗавершитьРедактированиеЯчейки(СтруктураСвязи, ТекущееЗначение, НомерСтрокиЯчейки, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум)
	
	ПредыдущееЗначениеИзРегистра = Неопределено;
	ПредыдущаяСуммаПоПартнеру = 0;
	ОбновитьЗначениеРегистра(СтруктураСвязи, ТекущееЗначение, ПредыдущееЗначениеИзРегистра, ПредыдущаяСуммаПоПартнеру);
	Дельта = ПредыдущееЗначениеИзРегистра - ТекущееЗначение;
	
	Если ЗначениеЗаполнено(СтруктураСвязи.Производитель) Или СтруктураСвязи.УровеньГруппировки = 3 Тогда
		//Изменение ячейки по бренду.
		ЗначенияГруппировок = Новый Структура("Производитель, ГруппаНоменклатуры, Партнер", СтруктураСвязи.Производитель, СтруктураСвязи.ГруппаНоменклатуры, СтруктураСвязи.Партнер);
		СтрокиГруппировок = ПолучитьГруппировкиОтчетаПоСвязям(ЗначенияГруппировок);
		
		Для Каждого Строка Из СтрокиГруппировок Цикл
			РедактируемаяОбласть = ДокументРезультат.Область(Строка.Ряд, ДокументРезультат.ШиринаТаблицы, Строка.Ряд, ДокументРезультат.ШиринаТаблицы);
			РедактируемаяОбласть.Значение = РедактируемаяОбласть.Значение - Дельта;
		КонецЦикла;
	ИначеЕсли ЗначениеЗаполнено(СтруктураСвязи.ГруппаНоменклатуры) Или СтруктураСвязи.УровеньГруппировки = 2 Тогда
		//Итоги по группе номенклатуры изменять запрещено.
		Возврат;
	Иначе
		//Изменение итогов по партнеру.
		ДобавитьПустыеСтроки = Истина;
		Если ПредыдущаяСуммаПоПартнеру = 0 Тогда
			//ДобавитьСтроки с суммой ТекущееЗначение
			СуммаПустойГруппы = ТекущееЗначение;
		Иначе
			Если ТекущееЗначение > ПредыдущаяСуммаПоПартнеру Тогда
				Если ПредыдущееЗначениеИзРегистра = 0 Тогда
					//ДобавитьСтроки с суммой ТекущееЗначение-ПредыдущаяСуммаПоПартнеру
					СуммаПустойГруппы = ТекущееЗначение - ПредыдущаяСуммаПоПартнеру;
				Иначе
					//ИзменитьСтроки с суммой ТекущееЗначение - ПредыдущаяСуммаПоПартнеру + ПредыдущееЗначениеИзРегистра
					ДобавитьПустыеСтроки = Ложь;
					СуммаПустойГруппы = ТекущееЗначение - ПредыдущаяСуммаПоПартнеру + ПредыдущееЗначениеИзРегистра;
				КонецЕсли;
			Иначе
				//ИзменитьСтроки с суммой ТекущееЗначение
				СуммаПустойГруппы = ТекущееЗначение;
				Если ПредыдущееЗначениеИзРегистра <> 0 Тогда
					ДобавитьПустыеСтроки = Ложь;
				КонецЕсли;
				//Очистить данные по строкам
				ОчиститьДанныеПоСтрокам(НомерСтрокиМинимум, НомерСтрокиМаксимум);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДобавитьПустыеСтроки Тогда
			ДобавитьПустуюГруппуВТабличныйДокумент(СтруктураСвязи.Партнер, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум, СуммаПустойГруппы);
		Иначе
			ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум + 1, "", СуммаПустойГруппы);
			ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум + 2, "", СуммаПустойГруппы);
		КонецЕсли;
			
		РедактируемаяОбласть = ДокументРезультат.Область(ДокументРезультат.ВысотаТаблицы, ДокументРезультат.ШиринаТаблицы, ДокументРезультат.ВысотаТаблицы, ДокументРезультат.ШиринаТаблицы);
		РедактируемаяОбласть.Значение = РедактируемаяОбласть.Значение + ТекущееЗначение - ПредыдущаяСуммаПоПартнеру;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьГруппировкиОтчетаПоСвязям(ЗначенияГруппировок)
	
	Результат = Новый Массив;
	УровеньГруппировки = 2;
	
	Для Каждого ЭлементСтруктуры Из ЗначенияГруппировок Цикл
		
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(ЭлементСтруктуры.Значение));
		ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
		ЗначенияГруппировок[ЭлементСтруктуры.Ключ] = ОписаниеТипа.ПривестиЗначение();
		
		ЗначенияГруппировок.Вставить("УровеньГруппировки", УровеньГруппировки);
		
		МассивСтрокГруппировок = СвязиВОтчете.НайтиСтроки(ЗначенияГруппировок);
		
		ЗначенияГруппировок.Удалить("УровеньГруппировки");
		
		УровеньГруппировки = ?(УровеньГруппировки = 1, 2, УровеньГруппировки) - 1;
		
		Для Каждого СтрокаГруппировок Из МассивСтрокГруппировок Цикл
			Результат.Добавить(СтрокаГруппировок);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьЗначениеРегистра(СтруктураСвязи, ТекущееЗначение, ПредыдущееЗначениеИзРегистра = Неопределено, ПредыдущаяСуммаПоПартнеру = 0)
	
	ТребуетсяОчисткаДанныхПоБрендам = Ложь;
	
	Если Не СтруктураСвязи.УровеньГруппировки = 3 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ПланПродажПоБрендам.Сумма), 0) КАК Сумма
		|ИЗ
		|	РегистрСведений.ПланПродажПоБрендам КАК ПланПродажПоБрендам
		|ГДЕ
		|	ПланПродажПоБрендам.Период = &Период
		|	И ПланПродажПоБрендам.Менеджер = &Менеджер
		|	И ПланПродажПоБрендам.Партнер = &Партнер";
		Запрос.УстановитьПараметр("Период", Объект.ПериодПланирования);
		Запрос.УстановитьПараметр("Менеджер", Объект.ОтветственныйМенеджер);
		Запрос.УстановитьПараметр("Партнер", СтруктураСвязи.Партнер);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ПредыдущееЗначениеИзРегистра = 0;
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					ПредыдущаяСуммаПоПартнеру = Выборка.Сумма;
				КонецЦикла;
		КонецЕсли;
	Иначе
		ПредыдущаяСуммаПоПартнеру = 0;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.ПланПродажПоБрендам.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Партнер = СтруктураСвязи.Партнер;
	МенеджерЗаписи.ГруппаНоменклатуры = СтруктураСвязи.ГруппаНоменклатуры;
	МенеджерЗаписи.Производитель = СтруктураСвязи.Производитель;
	МенеджерЗаписи.ПланПродаж = Объект.Ссылка;
	МенеджерЗаписи.Период = Объект.ПериодПланирования;
	МенеджерЗаписи.Менеджер = Объект.ОтветственныйМенеджер;
	
	МенеджерЗаписи.Прочитать();
	
	Если Не МенеджерЗаписи.Выбран() Тогда
		МенеджерЗаписи.Партнер = СтруктураСвязи.Партнер;
		МенеджерЗаписи.ГруппаНоменклатуры = СтруктураСвязи.ГруппаНоменклатуры;
		МенеджерЗаписи.Производитель = СтруктураСвязи.Производитель;
		МенеджерЗаписи.ПланПродаж = Объект.Ссылка;
		МенеджерЗаписи.Период = Объект.ПериодПланирования;
		МенеджерЗаписи.Менеджер = Объект.ОтветственныйМенеджер;
	КонецЕсли;
	
	Если СтруктураСвязи.УровеньГруппировки = 3 Тогда
		ПредыдущееЗначениеИзРегистра = МенеджерЗаписи.Сумма;
		МенеджерЗаписи.Сумма = ТекущееЗначение;
	Иначе
		ПредыдущееЗначениеИзРегистра = МенеджерЗаписи.Сумма;
		
		Если ТекущееЗначение > ПредыдущаяСуммаПоПартнеру Тогда
			МенеджерЗаписи.Сумма = ТекущееЗначение - ПредыдущаяСуммаПоПартнеру + ПредыдущееЗначениеИзРегистра;
		Иначе
			
			МенеджерЗаписи.Сумма = ТекущееЗначение;
			
			//Обнулим остальные записи.
			ТребуетсяОчисткаДанныхПоБрендам = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	МенеджерЗаписи.Записать();
	
	Если ТребуетсяОчисткаДанныхПоБрендам Тогда
		ОчиститьДанныеРегистраВРазрезеБрендов(СтруктураСвязи.Партнер, Объект.ПериодПланирования, Объект.ОтветственныйМенеджер);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидимостьЭлементаГруппаДобавитьВПлан()
	Элементы.ГруппаДобавитьВПлан.Видимость = СвязиВОтчете.Количество() > 0;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПустоеЗначениеРеквизита(Реквизит)
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(ТипЗнч(Реквизит));
	ОписаниеТипа = Новый ОписаниеТипов(МассивТипов);
	
	Возврат ОписаниеТипа.ПривестиЗначение();
	
КонецФункции

&НаСервере
Процедура ДобавитьПустуюГруппуВТабличныйДокумент(Партнер, НомерСтрокиГруппы, НомерСтрокиМинимум, НомерСтрокиМаксимум, Сумма)
	
	ВидимостьОбласти = ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМинимум + 2).Видимость;
	ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМинимум + 2).Видимость = Истина;
	
	ДокументРезультат.ВставитьОбласть(
		ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМинимум + 2),
		ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМинимум + 2),
		ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	ДокументРезультат.Область(НомерСтрокиМинимум + 1, , НомерСтрокиМинимум + 4).Видимость = ВидимостьОбласти;
	
	ДокументРезультат.Область(НомерСтрокиМинимум + 2, , НомерСтрокиМинимум + 2).Сгруппировать();
	
	ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум + 1, "", Сумма);
	ИзменитьСкопированнуюОбласть(НомерСтрокиМинимум + 2, "", Сумма);
	
	Для Каждого Строка Из СвязиВОтчете Цикл
		Если Строка.Ряд > НомерСтрокиМинимум Тогда
			Строка.Ряд = Строка.Ряд + 2;
		КонецЕсли;
	КонецЦикла;
	
	ДобавитьСвязьВОтчет(НомерСтрокиМинимум + 1, Новый Структура("Партнер, ГруппаНоменклатуры, Производитель", Партнер, ГруппаНоменклатурыПустая, ПроизводительПустая), 2);
	ДобавитьСвязьВОтчет(НомерСтрокиМинимум + 2, Новый Структура("Партнер, ГруппаНоменклатуры, Производитель", Партнер, ГруппаНоменклатурыПустая, ПроизводительПустая), 3);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьДанныеРегистраВРазрезеБрендов(Партнер, ПериодПланирования, ОтветственныйМенеджер)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПланПродажПоБрендам.Период,
	|	ПланПродажПоБрендам.Менеджер,
	|	ПланПродажПоБрендам.Партнер,
	|	ПланПродажПоБрендам.ГруппаНоменклатуры,
	|	ПланПродажПоБрендам.Производитель,
	|	ПланПродажПоБрендам.ПланПродаж,
	|	ПланПродажПоБрендам.Сумма
	|ИЗ
	|	РегистрСведений.ПланПродажПоБрендам КАК ПланПродажПоБрендам
	|ГДЕ
	|	ПланПродажПоБрендам.Период = &Период
	|	И ПланПродажПоБрендам.Менеджер = &Менеджер
	|	И ПланПродажПоБрендам.Партнер = &Партнер";
	Запрос.УстановитьПараметр("Период", ПериодПланирования);
	Запрос.УстановитьПараметр("Менеджер", ОтветственныйМенеджер);
	Запрос.УстановитьПараметр("Партнер", Партнер);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Выборка.Производитель) И Не ЗначениеЗаполнено(Выборка.ГруппаНоменклатуры) Тогда
			Продолжить;
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ПланПродажПоБрендам.СоздатьМенеджерЗаписи();
		
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеПоСтрокам(НомерСтрокиМинимум, НомерСтрокиМаксимум)
	
	Для Счетчик = НомерСтрокиМинимум + 1 По НомерСтрокиМаксимум Цикл
		РедактируемаяОбласть = ДокументРезультат.Область(Счетчик, ДокументРезультат.ШиринаТаблицы, Счетчик, ДокументРезультат.ШиринаТаблицы);
		РедактируемаяОбласть.Значение = 0;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти








