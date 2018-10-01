﻿
#Область ОбработчикиСобытийФормы


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновлениеЭлементовФормы();		

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект 	= Параметры.Объект;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресНастроекОбмена) Тогда
		
		АдресНастроекОбмена = Параметры.АдресНастроекОбмена;
		
		НастройкиОбмена 	= ПолучитьИзВременногоХранилища(АдресНастроекОбмена);
		
		лНастройкиСтатусовЗаказа = ПланыОбмена.Б_ОбменССайтом.ПолучитьЗначениеКлючаСтруктурыНастроек(НастройкиОбмена.Заказы, "НастройкиСтатусовЗаказа");
		
		Если лНастройкиСтатусовЗаказа = Неопределено тогда
			ИсточникСтатусов1С = "СтатусыЗаказов";	
		Иначе
			
			ИсточникСтатусов1С 	= лНастройкиСтатусовЗаказа.ИсточникСтатусов1С;
			СвойствоЗаказа 		= лНастройкиСтатусовЗаказа.СвойствоЗаказа;
			
			СоответствияЗначенийСвойствЗаказа.Загрузить(лНастройкиСтатусовЗаказа.СоответствияЗначенийСвойствЗаказа);	
			СоответствияСостоянийЗаказа.Загрузить(лНастройкиСтатусовЗаказа.СоответствияСостоянийЗаказа);	
			СоответствияСтатусовЗаказа.Загрузить(лНастройкиСтатусовЗаказа.СоответствияСтатусовЗаказа);	
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	Закрыть(ПрименитьНаСервере());
	
КонецПроцедуры

&НаСервере
Функция ПрименитьНаСервере()
	
	Настройки = ПолучитьИзВременногоХранилища(АдресНастроекОбмена);

	лНастройкиСтатусовЗаказа = Новый Структура;
	лНастройкиСтатусовЗаказа.Вставить("ИсточникСтатусов1С"					, ИсточникСтатусов1С);
	лНастройкиСтатусовЗаказа.Вставить("СвойствоЗаказа"						, СвойствоЗаказа);
	лНастройкиСтатусовЗаказа.Вставить("СоответствияЗначенийСвойствЗаказа"	, СоответствияЗначенийСвойствЗаказа.Выгрузить());
	лНастройкиСтатусовЗаказа.Вставить("СоответствияСостоянийЗаказа"		, СоответствияСостоянийЗаказа.Выгрузить());
	лНастройкиСтатусовЗаказа.Вставить("СоответствияСтатусовЗаказа"			, СоответствияСтатусовЗаказа.Выгрузить());
	
	Если Настройки.Заказы.Свойство("НастройкиСтатусовЗаказа") тогда
			Настройки.Заказы.НастройкиСтатусовЗаказа = лНастройкиСтатусовЗаказа;	
		Иначе
			Настройки.Заказы.Вставить("НастройкиСтатусовЗаказа", лНастройкиСтатусовЗаказа);
	КонецЕсли;
	
	лАдресНастроекОбмена = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресНастроекОбмена"	, лАдресНастроекОбмена);

	Возврат ПараметрыФормы;
	 
КонецФункции


#КонецОбласти


#Область ОбработчикиЭлементовФормы


&НаКлиенте
Процедура ИсточникДанных1СПриИзменении(Элемент)
	ОбновлениеЭлементовФормы();
КонецПроцедуры


#КонецОбласти


#Область Прочее


&НаКлиенте
Процедура ОбновлениеЭлементовФормы()
	
	Если ИсточникСтатусов1С = "СвойствоЗаказов" тогда
		
		Элементы.СтраницыИсточникиСтатусов.ТекущаяСтраница = Элементы.СтраницаСвойствоЗаказа;
		
	ИначеЕсли ИсточникСтатусов1С = "СостоянияЗаказов" тогда 
		Элементы.СтраницыИсточникиСтатусов.ТекущаяСтраница = Элементы.СтраницаСостоянияЗаказа;
	Иначе
		ИсточникСтатусов1С = "СтатусыЗаказов";	
		Элементы.СтраницыИсточникиСтатусов.ТекущаяСтраница = Элементы.СтраницаСтатусыЗаказа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьССайтаСтатусыЗаказов(Команда)
		
	Попытка	
		СтрокаCML = ЗагрузитьССайтаСтатусыЗаказовСервер();
		
		РазборИЗаписьСтатусов(Объект, СтрокаCML);
	Исключение
		
		Сообщить("Не удалось получить данные с сайта");
		
	КонецПопытки;

КонецПроцедуры


&НаСервере 
Функция ЗагрузитьССайтаСтатусыЗаказовСервер()
	
	СтрокаCML = ПланыОбмена.Б_ОбменССайтом.ПолучитьСлужебныеДанныеССайта(Объект);

	Возврат СтрокаCML;
	
КонецФункции

&НаСервере
Функция РазборИЗаписьСтатусов(УзелОбмена, СтрокаCML)
		
	ЧтениеXML = Новый ЧтениеXML;
		
	Попытка
		ЧтениеXML.УстановитьСтроку(СтрокаCML);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Возврат Ложь;
	КонецПопытки;
	
	ТзнСоответствий = Новый ТаблицаЗначений;
	ТзнСоответствий.Колонки.Добавить("ТаблицаДанных");	
	ТзнСоответствий.Колонки.Добавить("ВременнаяТаблица");	
	
	НовСтрока = ТзнСоответствий.Добавить();
	НовСтрока.ВременнаяТаблица 	= СоответствияЗначенийСвойствЗаказа.Выгрузить();
	СоответствияЗначенийСвойствЗаказа.Очистить();
	НовСтрока.ТаблицаДанных 	= СоответствияЗначенийСвойствЗаказа;
	
	НовСтрока = ТзнСоответствий.Добавить();
	НовСтрока.ВременнаяТаблица 	= СоответствияСостоянийЗаказа.Выгрузить();
	СоответствияСостоянийЗаказа.Очистить();
	НовСтрока.ТаблицаДанных 	= СоответствияСостоянийЗаказа;
	
	НовСтрока = ТзнСоответствий.Добавить();
	НовСтрока.ВременнаяТаблица 	= СоответствияСтатусовЗаказа.Выгрузить();
	СоответствияСтатусовЗаказа.Очистить();
	НовСтрока.ТаблицаДанных 	= СоответствияСтатусовЗаказа;
	
	лЭтоСтатусы		= Ложь;
	лЭтоИд 			= Ложь;
	лЭтоНазвание	= Ложь;
	
	Пока ЧтениеXML.Прочитать() Цикл
			
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Cтатусы" тогда
			лЭтоСтатусы = Истина;
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Cтатусы" тогда
			лЭтоСтатусы = Ложь;
		КонецЕсли;
		
		Если лЭтоСтатусы тогда
			
			Если ЧтениеXML.ТипУзла 	= ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Элемент" тогда
				СтруктураСтр = Новый Структура("Ид, Название, Касса")
			КонецЕсли;
			
				Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Название" тогда
					лЭтоНазвание = Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Название" тогда
					лЭтоНазвание = Ложь;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.ЛокальноеИмя = "Ид" тогда
					лЭтоИд = Истина;
				ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Ид" тогда
					лЭтоИд = Ложь;
				КонецЕсли;
				
				Если лЭтоНазвание И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.Название = ЧтениеXML.Значение;
				КонецЕсли;
				
				Если лЭтоИд И ЧтениеXML.ТипУзла = ТипУзлаXML.Текст тогда
					СтруктураСтр.Ид = ЧтениеXML.Значение;
				КонецЕсли;
			
			Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.ЛокальноеИмя = "Элемент" тогда
				
				Для Каждого ТекСтрока из ТзнСоответствий Цикл
				
					Результат = ТекСтрока.ВременнаяТаблица.Найти(СтруктураСтр.Ид,"ИдСтатуса");
					
					Если Результат = Неопределено тогда
							
						НовСтр = ТекСтрока.ТаблицаДанных.Добавить();
						НовСтр.ИдСтатуса 		= СтруктураСтр.Ид;
						НовСтр.НазваниеСтатуса 	= СтруктураСтр.Название;
							
					Иначе
						
						НовСтр = ТекСтрока.ТаблицаДанных.Добавить();
						НовСтр.ИдСтатуса 		= СтруктураСтр.Ид;
						НовСтр.НазваниеСтатуса 	= СтруктураСтр.Название;
						НовСтр.Статус 			= Результат.Статус;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции


#КонецОбласти

