﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции
	
Функция ЗарегистрироватьЗапрос(Запрос, ТипЗапроса) Экспорт
	
	СтруктураЗапроса = Новый Структура;
	
	СтруктураЗапроса.Вставить("HTTPМетод", Запрос.HTTPМетод);
	СтруктураЗапроса.Вставить("БазовыйURL", Запрос.БазовыйURL);
	СтруктураЗапроса.Вставить("Заголовки", Запрос.Заголовки);
	СтруктураЗапроса.Вставить("ОтносительныйURL", Запрос.ОтносительныйURL);
	СтруктураЗапроса.Вставить("ПараметрыURL", Запрос.ПараметрыURL);
	СтруктураЗапроса.Вставить("ПараметрыЗапроса", Запрос.ПараметрыЗапроса);
	СтруктураЗапроса.Вставить("ИдентификаторЗапроса", Строка(Новый УникальныйИдентификатор));
	СтруктураЗапроса.Вставить("ТипЗапроса", ТипЗапроса);
	СтруктураЗапроса.Вставить("ИмяВременногоФайла", ПолучитьИмяВременногоФайла());
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтруктураЗапроса);
	
	ЗапросJSON = ЗаписьJSON.Закрыть();
	
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХешированиеДанных.Добавить(ЗапросJSON);
	Идентификатор = НРег(СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", ""));
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Идентификатор = Идентификатор;
	МенеджерЗаписи.Дата = ТекущаяУниверсальнаяДата();
	МенеджерЗаписи.Запрос = Новый ХранилищеЗначения(ЗапросJSON);
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Записать(Ложь);
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Идентификатор;
	
КонецФункции

Функция ЗапросПоИдентификатору(Идентификатор) Экспорт
	
	Запрос = Неопределено;
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор = НРег(Идентификатор);
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Прочитать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если МенеджерЗаписи.Выбран() Тогда
		
		Если ТекущаяУниверсальнаяДата() - МенеджерЗаписи.Дата < ПередачаДанныхСлужебный.ПериодДействияВременногоИдентификатора() Тогда
			
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(МенеджерЗаписи.Запрос.Получить());
			Запрос = ПрочитатьJSON(ЧтениеJSON, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Запрос;
		
КонецФункции

Процедура ПродлитьДействиеВременногоИдентификатора(Идентификатор) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Идентификатор = НРег(Идентификатор);
	
	УстановитьПривилегированныйРежим(Истина);
	МенеджерЗаписи.Прочитать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если МенеджерЗаписи.Выбран() Тогда
		
		МенеджерЗаписи.Дата = ТекущаяУниверсальнаяДата();
		
		УстановитьПривилегированныйРежим(Истина);
		МенеджерЗаписи.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли