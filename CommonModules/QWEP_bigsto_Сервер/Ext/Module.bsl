﻿
Процедура КодТиповойВыводОстатковУТ11(Объект, ЭтоЗагрузкаПрайса) Экспорт

	ТаблицаУникальныхАртикулов = Объект.РезультатПоиска.Выгрузить(,"Артикул, Фирма");    
	ТаблицаУникальныхАртикулов.Свернуть("Артикул, Фирма");
	
	Для каждого Строка Из ТаблицаУникальныхАртикулов Цикл        	
        Если ПустаяСтрока(Строка.Артикул) ИЛИ ПустаяСтрока(Строка.Фирма) Тогда                	
            ТаблицаУникальныхАртикулов.Удалить(Строка);
        КонецЕсли; 
	КонецЦикла;
	
    МассивУникальныхАртикулов = ТаблицаУникальныхАртикулов.ВыгрузитьКолонку("Артикул");
	Запрос = Новый Запрос();
    Запрос.Текст = "ВЫБРАТЬ
    |	СпрНоменклатура.Ссылка КАК Номенклатура,
    |	СпрНоменклатура.Производитель КАК Производитель,
    |	СпрНоменклатура.Производитель.Наименование КАК Фирма,
    |	СпрНоменклатура.Наименование КАК Наименование,
    |	&Поставщик КАК Поставщик,
    |	СпрНоменклатура.Артикул КАК Артикул,
    |	СпрНоменклатура.Артикул КАК АртикулПоставщика,
    |	ИСТИНА КАК НоменклатураЕстьВБазе
    |ПОМЕСТИТЬ ВТ_Номенклатура
    |ИЗ
    |	Справочник.Номенклатура КАК СпрНоменклатура
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.АналогиТоваров.СрезПоследних(,АртикулДляПоиска ПОДОБНО ""%"" + &АртикулПоиска + ""%"") Аналог
	|ПО
	|	Аналог.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	Не ЕСТЬNULL(Аналог.Удалено, ЛОЖЬ) И НЕ СпрНоменклатура.ПометкаУдаления
    |   И НЕ СпрНоменклатура.Артикул ЕСТЬ NULL
    |	И (
	|		СпрНоменклатура.Артикул В (&МассивУникальныхАртикулов) ИЛИ 
	|		СпрНоменклатура.Артикул ПОДОБНО ""%"" + &АртикулПоиска + ""%""
	|		ИЛИ НЕ Аналог.Номенклатура ЕСТЬ NULL
	|		)
    |;
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |	ВТ_Номенклатура.Номенклатура,
    |	ВТ_Номенклатура.Производитель,
    | 	ВТ_Номенклатура.Фирма,
    |	ВТ_Номенклатура.Наименование,
    |	ВТ_Номенклатура.Поставщик,
    |	ВТ_Номенклатура.Артикул,
    |	ВТ_Номенклатура.АртикулПоставщика,
    |	ВТ_Номенклатура.НоменклатураЕстьВБазе,
    |	ЕСТЬNULL(СвободныеОстаткиОстатки.ВНаличииОстаток, 0) КАК ОстатокНаСкладе,
    |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, 0) КАК ЦенаЗначение,
    |	ВЫБОР
    |		КОГДА СвободныеОстаткиОстатки.Склад ЕСТЬ NULL 
    |			ТОГДА """"
    |		ИНАЧЕ СвободныеОстаткиОстатки.Склад.Наименование
    |	КОНЕЦ КАК Склад,
    |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних1.Цена, 0) КАК ЦенаПродажи
    |ИЗ
    |	ВТ_Номенклатура КАК ВТ_Номенклатура
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки.Остатки(
    |				,
    |				Номенклатура В
    |					(ВЫБРАТЬ
    |						ВТ_Номенклатура.Номенклатура
    |					ИЗ
    |						ВТ_Номенклатура)) КАК СвободныеОстаткиОстатки
    |		ПО ВТ_Номенклатура.Номенклатура = СвободныеОстаткиОстатки.Номенклатура
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
    |				,
    |				ВидЦены = &ЦенаПокупки
    |					И Номенклатура В
    |						(ВЫБРАТЬ
    |							ВТ_Номенклатура.Номенклатура
    |						ИЗ
    |							ВТ_Номенклатура)) КАК ЦеныНоменклатурыСрезПоследних
    |		ПО ВТ_Номенклатура.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
    |				,
    |				ВидЦены = &ЦенаПродажи
    |					И Номенклатура В
    |						(ВЫБРАТЬ
    |							ВТ_Номенклатура.Номенклатура
    |						ИЗ
    |							ВТ_Номенклатура)) КАК ЦеныНоменклатурыСрезПоследних1
    |		ПО ВТ_Номенклатура.Номенклатура = ЦеныНоменклатурыСрезПоследних1.Номенклатура";
	
    Запрос.УстановитьПараметр("МассивУникальныхАртикулов",МассивУникальныхАртикулов);    
    Запрос.УстановитьПараметр("АртикулПоиска",Объект.ОригинальныйАртикул);
    Запрос.УстановитьПараметр("ТекущаяДата",ТекущаяДата());
	
	Если Объект.ЭтоЗагрузкаПрайса Тогда
		Запрос.УстановитьПараметр("МассивУникальныхАртикулов", Новый Массив);
		Запрос.УстановитьПараметр("АртикулПоиска", "");
	КонецЕсли;
	
	Для Каждого СтрокаПараметр Из Объект.ПараметрыВыводаОстатковИзБазы Цикл
        Запрос.УстановитьПараметр(СтрокаПараметр.ИмяПараметра,СтрокаПараметр.ЗначениеПараметра);
    КонецЦикла;    
	
	Результат = Запрос.Выполнить().Выбрать();	    
    Пока Результат.Следующий() Цикл
        Если ЭтоЗагрузкаПрайса Тогда
        	Если НЕ Результат.ОстатокНаСкладе > 0 Тогда
        		Продолжить;
        	КонецЕсли;
        	НовСтрока = Объект.ПрайсЛист.Добавить();
        	ЗаполнитьЗначенияСвойств(НовСтрока,Результат);
        	Если Результат.ЦенаПродажи > 0 Тогда
            	НовСтрока.ЦенаЗначение = Результат.ЦенаПродажи;
        	КонецЕсли;        	
    		НовСтрока.Состояние = "В наличии";            
        	НовСтрока.НаличиеЗначение = Результат.ОстатокНаСкладе;        	                                    		
    		НовСтрока.Кратность = 1;
    		Если ПустаяСтрока(НовСтрока.Склад) Тогда
    			НовСтрока.Склад = "Склад выдачи";
    		КонецЕсли;
    		НовСтрока.Бренд = Результат.Фирма;
    	Иначе
        	НовСтрока = Объект.РезультатПоиска.Добавить();
        	ЗаполнитьЗначенияСвойств(НовСтрока,Результат);  
        	//НовСтрока.ОстатокНаСкладе = Результат.ОстатокНаСкладе;
        	Если Результат.ЦенаЗначение > 0 Тогда
            	НовСтрока.ЦенаФормат = Формат(Результат.ЦенаЗначение,"ЧДЦ=2; ЧН=") + " р.";
        	КонецЕсли;
        
        	Если Результат.ЦенаПродажи > 0 Тогда
            	НовСтрока.ЦенаПродажиФормат = Формат(Результат.ЦенаПродажи,"ЧДЦ=2; ЧН=") + " р.";
        	КонецЕсли;
        
        	Если Результат.ОстатокНаСкладе > 0 Тогда
            	НовСтрока.Состояние = "В наличии";
            	//НовСтрока.Купить = "В реализацию";
            	НовСтрока.НаличиеФормат = Формат(Результат.ОстатокНаСкладе,"ЧГ=") + " шт.";
            	НовСтрока.НаличиеЗначение = Результат.ОстатокНаСкладе;
            	НовСтрока.ИндексКартинкиСостояние = 1;
        	Иначе
            	НовСтрока.Состояние = "Нет на складе";
        	КонецЕсли;	
			
        	НовСтрока.СкладГород = "316";
        	НовСтрока.ИндексКартинкиФото = 1;
        	НовСтрока.ИндексКартинкиКорзина = 1;
        	НовСтрока.ИндексКартинкиИзбранное = 1;
    	КонецЕсли;
	КонецЦикла;
	
	// silber {
	
	Если Не ЭтоЗагрузкаПрайса Тогда
		
		ОбЗаказ =  Документы.ЗаказКлиента.СоздатьДокумент();
		ОбЗаказ.Дата 		= ТекущаяДата();
		ОбЗаказ.Партнер 	= Объект.Партнер;
		ОбЗаказ.Контрагент 	= Объект.Контрагент;
		ОбЗаказ.Соглашение 	= Объект.Скоглашение;
		
		СтруктураПараметры = Новый Структура;
		СтруктураПараметры.Вставить("ПрименятьКОбъекту",                Истина);
		СтруктураПараметры.Вставить("ТолькоПредварительныйРасчет",      Ложь);
		СтруктураПараметры.Вставить("ВосстанавливатьУправляемыеСкидки", Истина);
		СтруктураПараметры.Вставить("УправляемыеСкидки", Новый СписокЗначений);
		
		ОбЗаказ.СкидкиНаценкиСервер.РассчитатьПоЗаказуКлиента(ОбЗаказ, СтруктураПараметры);
		ОбЗаказ.СкидкиРассчитаны = Истина;
		
	КонецЕсли;
	
	// } silber

	
КонецПроцедуры