﻿&НаСервере
Функция ПолучитьСсылкуНаФайл() 
	
	Ссылка=ПоместитьВоВременноеХранилище(Справочники.МегаЛогист_Маркеры.ПолучитьМакет("Картинки"));
	Возврат Ссылка
	
КонецФункции

Процедура СоздатьОбновитьМаркер(Идентификатор,Картинки)
	
	ИмяМаркера="Маркер_"+Идентификатор;
	Маркер=Справочники.МегаЛогист_Маркеры.НайтиПоНаименованию(ИмяМаркера);
	
	Если НЕ Маркер.Пустая()  тогда
		Маркер=Маркер.ПолучитьОбъект();	
	иначе		
		Маркер=Справочники.МегаЛогист_Маркеры.СоздатьЭлемент();		
	КонецЕсли;	
	
	Маркер.Активный=?(Идентификатор=0,Ложь,Истина);
	Маркер.Наименование=ИмяМаркера;
	Маркер.ПоУмолчанию=?(Идентификатор=0,Истина,Ложь);
	
	Для Каждого Картинка из Картинки цикл
		
		Если Найти(Картинка.ИмяФайла,"adres_"+Идентификатор)>0 тогда 
			Маркер.Маркер1=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
		ИначеЕсли Найти(Картинка.ИмяФайла,"adres_oreol_"+Идентификатор)>0 тогда
			Маркер.Маркер2=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
		ИначеЕсли Найти(Картинка.ИмяФайла,"transport_"+Идентификатор)>0 тогда
			Маркер.Маркер3=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
		ИначеЕсли Найти(Картинка.ИмяФайла,"transport_oreol_"+Идентификатор)>0 тогда
			Маркер.ТССОреолом=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
		ИначеЕсли Найти(Картинка.ИмяФайла,"peshehod_"+Идентификатор)>0 тогда
			Маркер.ПешийКурьер=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));
		ИначеЕсли Найти(Картинка.ИмяФайла,"peshehod_oreol_"+Идентификатор)>0 тогда
			Маркер.ПешийСОреолом=Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Картинка.Адрес));			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Идентификатор=0 тогда
		Маркер.ЦветПолиЛинии="";
	ИначеЕсли Идентификатор=1 тогда
		Маркер.ЦветПолиЛинии="#22635E";
	ИначеЕсли Идентификатор=2 тогда
		Маркер.ЦветПолиЛинии="#003366";
	ИначеЕсли Идентификатор=3 тогда
		Маркер.ЦветПолиЛинии="#960018";
	ИначеЕсли Идентификатор=4 тогда
		Маркер.ЦветПолиЛинии="#CC5500";
	ИначеЕсли Идентификатор=5 тогда
		Маркер.ЦветПолиЛинии="#792079";
	ИначеЕсли Идентификатор=6 тогда
		Маркер.ЦветПолиЛинии="#B92D49";
	ИначеЕсли Идентификатор=7 тогда
		Маркер.ЦветПолиЛинии="#12633B";
	ИначеЕсли Идентификатор=8 тогда
		Маркер.ЦветПолиЛинии="#6C2325";
	ИначеЕсли Идентификатор=9 тогда
		Маркер.ЦветПолиЛинии="#032140";	
	ИначеЕсли Идентификатор=10 тогда
		Маркер.ЦветПолиЛинии="#F19104";
	КонецЕсли;
	
	Маркер.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзображения()
	
	СсылкаНаФайл = ПолучитьСсылкуНаФайл();
		
	ВременныйКаталог   = КаталогВременныхФайлов();
	ВременныйФайл      = ВременныйКаталог + "Маркеры.zip";
	КаталогИнсталляции = ВременныйКаталог + "Маркеры\";
	
	// Распаковка архива во временный каталог.
	Результат = ПолучитьФайл(СсылкаНаФайл, ВременныйФайл, Ложь);
	
	ФайлАрхива = Новый ЧтениеZipФайла();
	ФайлАрхива.Открыть(ВременныйФайл);
	ФайлАрхива.ИзвлечьВсе(КаталогИнсталляции);
	ФайлАрхива.Закрыть();
		
	Для а=0 по 100 цикл
		НайденныеФайлы = НайтиФайлы(КаталогИнсталляции, "*"+а+".png",Истина);
		Если НайденныеФайлы.Количество()>0 тогда
			
			МассивАдресов=Новый Массив;
			
			Для Каждого НайденныйФайл из НайденныеФайлы цикл
				АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(НайденныйФайл.ПолноеИмя));
				МассивАдресов.Добавить(Новый Структура("Адрес,ИмяФайла",АдресВоВременномХранилище,НайденныйФайл.ПолноеИмя));
			КонецЦикла;
			
			СоздатьОбновитьМаркер(а,МассивАдресов);		
			
		КонецЕсли;	
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	ЗагрузитьИзображения();
КонецПроцедуры
