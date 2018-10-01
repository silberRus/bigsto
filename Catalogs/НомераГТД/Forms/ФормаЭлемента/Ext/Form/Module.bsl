﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОповеститьОВыборе(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Заголовок = НСтр("ru = 'Номер таможенной декларации'");
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры


#КонецОбласти
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТекущийТекстНомераДекларации = Текст;
	ПодключитьОбработчикОжидания("Подключаемый_ВывестиИнформациюОбОшибкахВНомере", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	ТекущийТекстНомераДекларации = Объект.Код;
	КодПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	КорректныйПериод = КорректныйПериодВводаДокументов();
	
	НачалоКорректногоПериода = КорректныйПериод.НачалоКорректногоПериода;
	КонецКорректногоПериода  = КорректныйПериод.КонецКорректногоПериода;
	
	ТекущийТекстНомераДекларации = Объект.Код;
	КодОшибки = НаличиеОшибокВНомереДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
	
	УправлениеПодсказками(ЭтотОбъект);
	ОбновитьЭлементыФормы();

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	
	ПолучитьСсылкуТаможеннойДекларации();
	СформироватьПредставлениеНомераТД();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеНомераТД()
	
	Если ЗначениеЗаполнено(Объект.РегистрационныйНомер) И ЗначениеЗаполнено(ТаможеннаяДекларация) Тогда
		Часть1 = Новый ФорматированнаяСтрока(НСтр("ru = 'Зарегистрирована декларация:'") + " ");
		Часть2 = Новый ФорматированнаяСтрока(Объект.РегистрационныйНомер,,,,ТаможеннаяДекларация);
		Элементы.ПредставлениеНомераТД.Заголовок = Новый ФорматированнаяСтрока(Часть1, Часть2);
		Элементы.ПредставлениеНомераТД.Видимость = Истина;
	Иначе
		Элементы.ПредставлениеНомераТД.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСсылкуТаможеннойДекларации()
	
	Если Не Объект.СтранаВвозаНеРФ И ЗначениеЗаполнено(Объект.РегистрационныйНомер) Тогда
		ТаможеннаяДекларацияСсылка = Документы.ТаможеннаяДекларацияИмпорт.НайтиПоРеквизиту("НомерДекларации", Объект.РегистрационныйНомер);
		Если Не ТаможеннаяДекларацияСсылка.Пустая() Тогда
			ТаможеннаяДекларация = ПолучитьНавигационнуюСсылку(ТаможеннаяДекларацияСсылка);
		Иначе
			ТаможеннаяДекларация = "";
		КонецЕсли;
	Иначе
		ТаможеннаяДекларация = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КодПриИзмененииНаСервере()
	
	Реквизиты = Справочники.НомераГТД.РегистрационныйНомерИСтранаВвоза(ТекущийТекстНомераДекларации);
	ЗаполнитьЗначенияСвойств(Объект, Реквизиты, "РегистрационныйНомер,СтранаВвозаНеРФ,ПорядковыйНомерТовара");
	
	КодОшибки = НаличиеОшибокВНомереДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
		
	УправлениеПодсказками(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеПодсказками(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.НомерОшибочнаяСтруктура.Видимость    = Форма.КодОшибки = 1;
	Элементы.КодТаможенногоОрганаДлина.Видимость  = Форма.КодОшибки = 2;
	Элементы.ДатаДекларацииДлина.Видимость        = Форма.КодОшибки = 3;
	Элементы.ДатаДекларацииОшибочная.Видимость    = Форма.КодОшибки = 4;
	Элементы.ПорядковыйНомерДлина.Видимость       = Форма.КодОшибки = 5;
	Элементы.ПорядковыйНомерТовараДлина.Видимость = Форма.КодОшибки = 6;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НаличиеОшибокВНомереДекларации(НомерТаможеннойДекларации, НачалоКорректногоПериода, КонецКорректногоПериода)
	
	НомерДекларацииНаТовары = СокрЛП(НомерТаможеннойДекларации);
	
	Если НЕ ЗначениеЗаполнено(НомерДекларацииНаТовары) Тогда
		// Пользователь еще ничего не ввел.
		Возврат 0;
	КонецЕсли;
	
	МассивТД = СтрРазделить(НомерДекларацииНаТовары, "/");
	
	Если МассивТД.Количество() > 4
	 ИЛИ МассивТД.Количество() < 3 Тогда
		// Ошибочное количество элементов.
		Возврат 1;
	КонецЕсли;
	
	КодТаможенногоОргана = МассивТД[0];
	
	Если СтрДлина(КодТаможенногоОргана) <> 2
		И СтрДлина(КодТаможенногоОргана) <> 5
		И СтрДлина(КодТаможенногоОргана) <> 8 Тогда
		// Ошибочная длина кода таможенного органа.
		Возврат 2;
	КонецЕсли;
	
	ДатаПринятияДекларацииНаТовары = МассивТД[1];
	
	Если СтрДлина(ДатаПринятияДекларацииНаТовары) <> 6 Тогда
		// Ошибочная длина поля дата.
		Возврат 3;
	Иначе
		// Проверим корректность указания даты.
		Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДатаПринятияДекларацииНаТовары) Тогда
			// Длина поля верная, но дата указана ошибочно.
			Возврат 3;
		КонецЕсли; 
		
		СтрокаВДату = СтроковыеФункцииКлиентСервер.СтрокаВДату(ДатаПринятияДекларацииНаТовары);
		Если НЕ ЗначениеЗаполнено(СтрокаВДату) Тогда
			// Длина поля верная, но дата указана ошибочно.
			Возврат 3;
		Иначе
			// Проверим год на корректность указания.
			
			Если СтрокаВДату < НачалоКорректногоПериода 
			 ИЛИ СтрокаВДату > КонецКорректногоПериода Тогда
				Возврат 4;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ПорядковыйНомерДекларацииНаТовары = МассивТД[2];
	
	Если СтрДлина(ПорядковыйНомерДекларацииНаТовары) <> 7 Тогда
		// Ошибочная длина поля порядковый номер.
		Возврат 5;
	КонецЕсли;
	
	Если МассивТД.Количество() = 4 Тогда
		ПорядковыйНомерТовара = МассивТД[3];
		Если СтрДлина(ПорядковыйНомерТовара) > 3
		 ИЛИ СтрДлина(ПорядковыйНомерТовара) < 1 Тогда
			// Ошибочная длина поля порядковый номер товара.
			Возврат 6;
		КонецЕсли;
	КонецЕсли;
	
	Возврат 0;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ВывестиИнформациюОбОшибкахВНомере() Экспорт
	
	КодОшибки = НаличиеОшибокВНомереДекларации(
		ТекущийТекстНомераДекларации, НачалоКорректногоПериода, КонецКорректногоПериода);
	УправлениеПодсказками(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция КорректныйПериодВводаДокументов()
	
	// Контролируем ошибку на один разряд. Например, 0017 вместо 2017; 2071 вместо 2017.
	// Допустимым считаем ввод документов на 9 лет в будущем. Например, в 2020 году разрешаем
	// вводить даты в интервале с января 2000 по декабрь 2029.
	
	КонецКорректногоПериода = ДобавитьМесяц(КонецГода(ТекущаяДатаСеанса()), 9 * 12);
	
	КорректныйПериод = Новый Структура;
	КорректныйПериод.Вставить("НачалоКорректногоПериода", Дата(2000, 01, 01));
	КорректныйПериод.Вставить("КонецКорректногоПериода",  КонецКорректногоПериода);
	Возврат КорректныйПериод;
	
КонецФункции

#КонецОбласти