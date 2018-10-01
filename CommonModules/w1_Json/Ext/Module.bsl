﻿
Функция ПолучитьМассивИзТаблицыЗначений(Т)
	
	i = Новый Массив;
	Для Каждого К Из Т.Колонки Цикл i.Добавить(К.Имя) КонецЦикла;
	П = СтрСоединить(i, ",");
	
	В = Новый Массив;
	Для Каждого С Из Т Цикл S = Новый Структура(П); ЗаполнитьЗначенияСвойств(S, С); В.Добавить(S); КонецЦикла;
	
	Возврат В;
	
КонецФункции

Функция ПреобразованиеЗаписиJSON(Свойство, Значение, ДополнительныеПараметры, Отказ) Экспорт
	
	Если ТипЗнч(Значение) = Тип("ТаблицаЗначений") Тогда
		Возврат ПолучитьМассивИзТаблицыЗначений(Значение);
	Иначе
		Возврат XMLСтрока(Значение);
	КонецЕсли;
	
КонецФункции
Процедура ПреобразованиеЧтенияJSON(Свойство, Значение, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("Типы") Тогда
		
		текПолноеИмя = ДополнительныеПараметры.Типы[Свойство];
		Если текПолноеИмя <> Неопределено Тогда
			
			Мета = Метаданные.НайтиПоПолномуИмени(текПолноеИмя);
			Если Метаданные.Справочники.Содержит(мета) Тогда
				Значение = Справочники[текПолноеИмя].ПолучитьСсылку(Новый УникальныйИдентификатор(Значение));
			ИначеЕсли Метаданные.Документы.Содержит(мета) Тогда
				Значение = Документы[текПолноеИмя].ПолучитьСсылку(Новый УникальныйИдентификатор(Значение)); КонецЕсли; КонецЕсли; КонецЕсли;
	
КонецПроцедуры


Функция JSON36(Значение, ЗначениеВXML = Ложь, ПараметрыЗаписиJSON = Неопределено) Экспорт
	
	НастройкаСериализации = Новый НастройкиСериализацииJSON;
	НастройкаСериализации.ВариантЗаписиДаты 				= ВариантЗаписиДатыJSON.УниверсальнаяДата;
	НастройкаСериализации.СериализовыватьМассивыКакОбъекты 	= Ложь;
	НастройкаСериализации.ФорматСериализацииДаты 			= ФорматДатыJSON.ISO;
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку(?(ПараметрыЗаписиJSON = Неопределено, Новый ПараметрыЗаписиJSON, ПараметрыЗаписиJSON));
	ЗаписатьJSON(Запись, Значение, НастройкаСериализации, "ПреобразованиеЗаписиJSON", w1_Json, Новый Структура("ЗначениеВXML", ЗначениеВXML));
	
	Возврат Запись.Закрыть();
	
КонецФункции
Функция UnJSON36(стрJSON, ПрочитатьВСоответствие = Ложь, ИменаСвойствСоЗначениямиДата = Неопределено, стрОшибки = "") Экспорт
	
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(стрJSON);
	
	Попытка
		Возврат ПрочитатьJSON(Чтение, ПрочитатьВСоответствие,ИменаСвойствСоЗначениямиДата,,"ПреобразованиеЧтенияJSON", w1_Json);
	Исключение
		опОшибки = ОписаниеОшибки();
		стрОшибки = "Ошибка чтения JSON: " + опОшибки; КонецПопытки;
	
КонецФункции

// ------------------

Функция JSON(Значение, ЗначениеВXML = Ложь, ЭтоКорневоеЗначение = Истина) Экспорт
// ЭтоКорневоеЗначение - флаг, что мы пытаемся превратить в JSON внешний объект, а не внутреннюю часть объекта
// Суть в том, что в Rails функция JSON.parse падает, если туда передать "" или "null" или "\"\"", но некоторые функции в 1С возвращают неопределено или ""
// Тогда если мы хотим превратить в JSON пустую строку, то получим {}, но если пустая строка будет значением некоторого свойства, 
// то она превратится в обычную "\"\""

	Разделитель="";
	
	Если ЭтоКорневоеЗначение И (Значение = "" ИЛИ Значение = Неопределено) Тогда
		Значение = Новый Структура;
	КонецЕсли;
	
	ТипЗн=ТипЗнч(Значение);
	
	Если ТипЗн=Тип("Строка") Тогда
		
		Стр=""""+Маскировать(Значение)+""""
		
	ИначеЕсли ТипЗн=Тип("Число") ИЛИ ТипЗнч(Значение)=Тип("Булево") Тогда
		Стр=XMLСтрока(Значение)
		
	ИначеЕсли ТипЗн=Тип("Дата") Тогда
		Стр=""""+?(ЗначениеЗаполнено(Значение),XMLСтрока(Значение),"")+""""
		
	ИначеЕсли ТипЗн=Тип("Структура") Или ТипЗн=Тип("Соответствие") Тогда
		Стр="{";
		//Для Каждого Параметр Из Значение Цикл Если НеВыгружатьПараметр(Параметр) Тогда Продолжить; КонецЕсли; Стр=Стр+Разделитель+"""" + Параметр.Ключ + """:"+JSON(Параметр.Значение, ЗначениеВXML, Ложь); Разделитель=","; КонецЦикла;
		//Стр=Стр+"}";

		Для Каждого Параметр Из Значение Цикл Если НеВыгружатьПараметр(Параметр) Тогда Продолжить; КонецЕсли; Стр=Стр+Разделитель+Символы.ПС+"""" + Параметр.Ключ + """:"+JSON(Параметр.Значение, ЗначениеВXML, Ложь); Разделитель=","; КонецЦикла;
		Стр=Стр+Символы.ПС+"}";
		
	ИначеЕсли ТипЗн=Тип("Массив") Тогда
		Стр="[";
		//Для Каждого Элемент Из Значение Цикл Стр=Стр+Разделитель+JSON(Элемент, ЗначениеВXML, Ложь); Разделитель=","; КонецЦикла;
		//Стр=Стр+"]";

		Для Каждого Элемент Из Значение Цикл Стр=Стр+Разделитель+Символы.ПС+JSON(Элемент, ЗначениеВXML, Ложь); Разделитель=","; КонецЦикла;
		Стр=Стр+Символы.ПС+"]";
		
	ИначеЕсли ТипЗн=Тип("ТаблицаЗначений") Тогда
		
		Колонки= Значение.Колонки;
		Массив = Новый Массив;
		Для Каждого СтрокаТЗ Из Значение Цикл Структура = Новый Структура; Для Каждого Колонка Из Колонки Цикл Структура.Вставить(Колонка.Имя,СтрокаТЗ[Колонка.Имя]); КонецЦикла; Массив.Добавить(Структура); КонецЦикла;
		Стр=JSON(Массив, ЗначениеВXML, Ложь)
		
	ИначеЕсли ТипЗн=Тип("Картинка") Тогда
		
		Стр= """" + МаскироватьКартинку(XMLСтрока(Значение.ПолучитьДвоичныеДанные())) + """";
		
	ИначеЕсли Значение = Неопределено Тогда
		
		Стр="null"
		//Возврат null;
		
	Иначе
		
		теЗнач = Значение;
		Если ЗначениеВXML Тогда
			теЗнач = XMLСтрока(Значение);
			//Если теЗнач = "00000000-0000-0000-0000-000000000000" Тогда теЗнач = ""; КонецЕсли; КонецЕсли;
		Если теЗнач = "00000000-0000-0000-0000-000000000000" Тогда теЗнач = null; КонецЕсли; КонецЕсли;
		
		Стр = ?(теЗнач = null или Значение = null, "null", """" + Маскировать(теЗнач) + """");
		
	КонецЕсли;
	
	Возврат Стр
	  
КонецФункции

Функция МаскироватьКартинку(Стр) Экспорт
	
	Стр=СтрЗаменить(Стр,Символы.ПС,"\n");
	Стр=СтрЗаменить(Стр,Символы.ВК,"\r");
	//Стр=СтрЗаменить(Стр,"+","\+");
	//Стр=СтрЗаменить(Стр,"""","\""");
	//Стр=СтрЗаменить(Стр,"'","\'");
	Возврат Стр
	  
КонецФункции
Функция Маскировать(Знач Стр) Экспорт
	
	
    Стр=СтрЗаменить(Стр,"\","\\");  //*
	//Стр=СтрЗаменить(Стр,"\""",""""); 
	Стр=СтрЗаменить(Стр,Символы.ПС,"\n");
	Стр=СтрЗаменить(Стр,Символы.ВК,"\r");
	Стр=СтрЗаменить(Стр,"""","\"""); 
	
	
	//Стр=СтрЗаменить(Стр,"'","\'"); //*
	Стр=СтрЗаменить(Стр,"/","\/");   //*
		
	Стр=СтрЗаменить(Стр, Символы.Таб,"\t");
	//Стр=СтрЗаменить(Стр,"\f","\\f");
	//Стр=СтрЗаменить(Стр,"\b","\\b");
	
	Возврат Стр
	  
КонецФункции
Функция Маскировать_ст(Знач Стр) Экспорт
	
	Стр=СтрЗаменить(Стр,"\","\\");
	Стр=СтрЗаменить(Стр,Символы.ПС,"\n");
	Стр=СтрЗаменить(Стр,Символы.ВК,"\r");
	Стр=СтрЗаменить(Стр,"""","\\""");
	Стр=СтрЗаменить(Стр,"'","\'");
	Возврат Стр
	  
КонецФункции
  
Функция НеВыгружатьПараметр(Параметр)
	Если Параметр.Ключ = "ПометкаУдаления" ИЛИ Параметр.Ключ = "ВыгружатьНаСайт" Тогда Возврат Истина; КонецЕсли;
	
	Возврат Ложь;
КонецФункции // НеВыгружатьПараметр()

// МОЙ Мегапарсер

Функция ПолучитьСледующийСимволJson(Строка, Позиция, ПропускатьПробелыИтД = Истина)
	
	Позиция = Позиция + 1;
	Символ 	= Сред(Строка, Позиция, 1);
	
	Если Символ = "" Тогда // все кончилось
		Возврат "";
	КонецЕсли;
	
	Если ПропускатьПробелыИтД И
			(	ПустаяСтрока(Символ) Или 
				Символ = Символы.ПС Или 
				Символ = Символы.ВК Или 
				Символ = Символы.ВК Или 
				Символ = Символы.ВТаб Или 
				Символ = Символы.НПП Или 
				Символ = Символы.ПФ
			) Тогда
			
		Возврат ПолучитьСледующийСимволJson(Строка, Позиция);
		
	КонецЕсли;
	
	Возврат Символ;
	
КонецФункции

Функция СимволПохожНаОднихИзНих(Символ, Они)
	
	// переведем все в один регистр
	
	ОниБольшие 		= ВРЕГ(Они);
	СимволБольшой 	= ВРЕГ(Символ);
	
	Возврат Булево(Найти(ОниБольшие, СимволБольшой));
	
КонецФункции

Функция ПолучитьМассивJson(Строка, Позиция)
	
	Массив = Новый Массив;
	
	Пока Истина Цикл
		
		// Получим элемент
		Массив.Добавить(ПолучитьЗначениеJson(Строка, Позиция));
		
		// Проверим закончит може или не
		
		Символ = ПолучитьСледующийСимволJson(Строка, Позиция);
		
		Если Символ = "]" Тогда
			
			Возврат Массив; // все закончилось
			
		ИначеЕсли Символ = "," Тогда // следующий элемент массива
			
			Продолжить;
			
		ИначеЕсли пустаяСтрока(Символ) Тогда
			
			ВызватьИсключение "Ошибка разбора, внезапно закончился массив, позиция " + Позиция;
			
		Иначе
			
			ВызватьИсключение "Ошибка разбора, нет окончания или перечисления элементов массива, позиция " + Позиция;
			
		КонецЕсли;
	КонецЦикла;
	
КонецФункции
Функция ПолучитьСтрокуJson(Строка, Позиция)
	
	Текст	= "";
	Символ 	= ПолучитьСледующийСимволJson(Строка, Позиция);
		
	
	Пока Символ <> """" Цикл
	   
		Текст = Текст + Символ;
	   
		Если Символ = "\" Тогда
			
			Символ 	= ПолучитьСледующийСимволJson(Строка, Позиция);
			Если пустаяСтрока(Символ) Тогда
				Прервать;
			КонецЕсли;
			
			Если Символ = "n" Тогда
				Текст = Текст + Символы.ПС;
			ИначеЕсли Символ = "r" Тогда
				Текст = Текст + Символы.ВК;
			ИначеЕсли Символ = """" Тогда
				Текст = Текст + """";
			ИначеЕсли Символ = "'" Тогда
				Текст = Текст + "'";
			КонецЕсли;
			
		КонецЕсли;
		
		Символ 	= ПолучитьСледующийСимволJson(Строка, Позиция, Ложь);
		Если Символ = "" Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Текст;
   	
КонецФункции
Функция ПолучитьЧислоJson(Строка, Позиция)
	
	ЦифрыСтр 	= "+-1234567890.eE";
   	ЧислоСтр 	= "0";
	Символ 		= ПолучитьСледующийСимволJson(Строка, Позиция);
	
	Пока 	Не ПустаяСтрока(Символ) И 
			Найти(ЦифрыСтр, Символ) Цикл
		
		ЧислоСтр 	= ЧислоСтр + Символ;
		Символ 		= ПолучитьСледующийСимволJson(Строка, Позиция);
		
	КонецЦикла;
	
	Позиция = Позиция - 1; // отъедим назад а то потом никто не смогет прочитать следуюзий цифра, т.к. перепрыгнет на одну
	
	Возврат Число(ЧислоСтр);
   
КонецФункции


Функция ПолучитьЗначениеJson(Строка, Позиция = 0, пТип = "")
	
	Символ = ПолучитьСледующийСимволJson(Строка, Позиция);
	
	Если Символ = "{" Тогда
    	Возврат ПолучитьОбъектJson(Строка, Позиция);
   	КонецЕсли;
	
	Если Символ = "[" И Сред(Строка, Позиция + 1, 1) = "]" Тогда
		
		Позиция = Позиция + 1;
		
		// Пустой массив
		Возврат Новый Массив;
		
	ИначеЕсли Символ = "[" Тогда
		
		Возврат ПолучитьМассивJson(Строка, Позиция);
		
	ИначеЕсли Символ = """" ИЛИ НРег(пТип) = "строка" Тогда
   
		Возврат ПолучитьСтрокуJson(Строка, ?(Символ = """", Позиция, Позиция-1));
		
	ИначеЕсли СимволПохожНаОднихИзНих(Символ, "1234567890+-.eE") Тогда
		
		Позиция = Позиция - 1;
       	Возврат ПолучитьЧислоJson(Строка, Позиция);
	   
	ИначеЕсли ВРЕГ(Сред(Строка, Позиция, 4)) = "TRUE" Тогда
		
		Позиция = Позиция + 3;
		Возврат Истина;
		
	ИначеЕсли ВРЕГ(Сред(Строка, Позиция, 5)) = "FALSE" Тогда
		
		Позиция = Позиция + 4;
		Возврат Ложь;
		
	ИначеЕсли ВРЕГ(Сред(Строка, Позиция, 4)) = "NULL" Тогда
		
		Позиция = Позиция + 3;
		Возврат Неопределено;

	Иначе
		
		ВызватьИсключение "Ошибка разбора, при чтения значения не ясен тип значения, позиция " + Позиция;
		
	КонецЕсли;
	
КонецФункции
Функция ПолучитьОбъектJson(Строка, Позиция)
	
	Объект 				= Новый Структура;
	ИмяОбъекта 			= "";
	ЧтениеИмениОбъекта 	= Ложь;
	
	Пока Истина Цикл
		
		Символ = ПолучитьСледующийСимволJson(Строка, Позиция);
		
		Если Символ = """" Тогда
			
			Если Не ЧтениеИмениОбъекта Тогда
				
				ЧтениеИмениОбъекта = Истина;
				
			Иначе // закончилось чтение имени объекта, дальше идет значение
				
				ЧтениеИмениОбъекта = Ложь;
				
			КонецЕсли;
				
		ИначеЕсли Символ = "}" И Не ЧтениеИмениОбъекта Тогда
			
			Возврат Объект; // все закончилось
			
		ИначеЕсли Символ = ":" И Не ЧтениеИмениОбъекта Тогда // название закончилось
			
			Если ИмяОбъекта = "" Тогда
				ИмяОбъекта = "Структура";
			КонецЕсли;
			
			Объект.Вставить(ИмяОбъекта, ПолучитьЗначениеJson(Строка, Позиция));
			
		ИначеЕсли Символ = ","  И Не ЧтениеИмениОбъекта Тогда // следующий объект
			
			ИмяОбъекта = ""; // сброс
			
		ИначеЕсли Символ = "" Тогда
			
			Если ЧтениеИмениОбъекта Тогда
				ВызватьИсключение "Ошибка разбора, внезапно закончилось имя объекта " + ИмяОбъекта + " позиция " + Позиция;
			Иначе
				ВызватьИсключение "Ошибка разбора, внезапно закончился объект " + ИмяОбъекта + " позиция " + Позиция;
			КонецЕсли;
			
		ИначеЕсли ЧтениеИмениОбъекта Тогда
			
			ИмяОбъекта 	= ИмяОбъекта + Символ;
			
		Иначе
			
			ВызватьИсключение "Ошибка чтения объекта " + ИмяОбъекта + " позиция " + Позиция;
			
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

Функция UnJSON(Строка, стрОшибки = "", пТип = "") Экспорт
	
	Если ПустаяСтрока(Строка) Тогда
		
		Возврат Новый Структура;
		
	КонецЕсли;
	
	Попытка
		
		Возврат ПолучитьЗначениеJson(Строка, , пТип);
		
	Исключение
		
		стрОшибки = ОписаниеОшибки();
		Возврат Неопределено;
		
	КонецПопытки;
	
КонецФункции