﻿
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если Параметры.Свойство("Источник") И ЗначениеЗаполнено(Параметры.Источник) Тогда
        Источник = Параметры.Источник;
        Элементы.УчетнаяСистема.Видимость = Ложь;
        КоманднаяПанель.Видимость = Ложь;
        АвтоЗаголовок = Ложь;
        Заголовок = ИнтеграцияОбъектовОбластейДанныхПовтИсп.СловарьПодсистемы().Настройки; 
    КонецЕсли; 
    
    Если ЗначениеЗаполнено(Запись.УчетнаяСистема) Тогда
        УстановитьПривилегированныйРежим(Истина);
        КлючПодписи = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "КлючПодписи");
        Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "Пароль");
        ДанныеСертификата = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "ДанныеСертификата"); 
        АдресДанныхСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
        ПарольСертификата = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "ПарольСертификата");
        УстановитьПривилегированныйРежим(Ложь);
    КонецЕсли; 
    
    ЗапрашиватьЛогинПароль = Запись.СпособАутентификации = ПредопределенноеЗначение("Перечисление.СпособыАутентификации.ОбычнаяПроверка");
    Элементы.ГруппаСпособАутентификации.Доступность = ЗапрашиватьЛогинПароль;
    Элементы.ИмяСертификата.Доступность = Запись.ИспользоватьСертификат;
    Элементы.ПарольСертификата.Доступность = Запись.ИспользоватьСертификат;
    Элементы.КлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    Элементы.ПоказатьКлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    
    УстановитьПривилегированныйРежим(Истина);
    ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, КлючПодписи, "КлючПодписи");
    ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, Пароль, "Пароль");
    Если ЗначениеЗаполнено(АдресДанныхСертификата) Тогда
        ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресДанныхСертификата);
        ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, ДанныеСертификата, "ДанныеСертификата");
    КонецЕсли; 
    ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, ПарольСертификата, "ПарольСертификата");
    УстановитьПривилегированныйРежим(Ложь);
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы
    
&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры
 
&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
    
    ПарольИзменен = Истина;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура СпособАутентификацииПриИзменении(Элемент)
    
    ЗапрашиватьЛогинПароль = Запись.СпособАутентификации = ПредопределенноеЗначение("Перечисление.СпособыАутентификации.ОбычнаяПроверка");
    Элементы.ГруппаСпособАутентификации.Доступность = ЗапрашиватьЛогинПароль;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСертификатПриИзменении(Элемент)
    
    Элементы.ИмяСертификата.Доступность = Запись.ИспользоватьСертификат;
    Элементы.ПарольСертификата.Доступность = Запись.ИспользоватьСертификат;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ИмяСертификатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПомещениеСертификатаКлиентаЗавершение", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение, , , Истина, УникальныйИдентификатор);
    
КонецПроцедуры

&НаКлиенте
Процедура ИмяСертификатаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПустаяСтрока(Запись.ИмяСертификата) Тогда
		
		Адрес = ?(СертификатКлиентаИзменен, АдресДанныхСертификата, ПоместитьСертификатКлиентаВоВременноеХранилище());
		ПолучитьФайл(Адрес, Запись.ИмяСертификата, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписыватьДанныеПриИзменении(Элемент)
    
    Элементы.КлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    Элементы.ПоказатьКлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ОповещатьСервисОбИзмененияхПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура АдресСервисаПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ИмяСертификатаПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ПарольСертификатаПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура КлючПодписиПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
    
&НаКлиенте
Процедура ПоказатьКлючПодписи(Команда)
    
    Если Элементы.СтраницыКлючЗаписи.ТекущаяСтраница = Элементы.СтраницаЗакрыто Тогда
        Элементы.СтраницыКлючЗаписи.ТекущаяСтраница = Элементы.СтраницаОткрыто;    
    Иначе
        Элементы.СтраницыКлючЗаписи.ТекущаяСтраница = Элементы.СтраницаЗакрыто;
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПомещениеСертификатаКлиентаЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	АдресДанныхСертификата = Адрес;
	ЧастиИмени = СтрРазделить(ВыбранноеИмяФайла, ПолучитьРазделительПути(), Ложь);
	Запись.ИмяСертификата = ЧастиИмени[ЧастиИмени.ВГраница()];
	СертификатКлиентаИзменен = Истина;
	ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаСервере
Функция ПоместитьСертификатКлиентаВоВременноеХранилище()
    
    УстановитьПривилегированныйРежим(Истина);
    ДанныеСертификата = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "ДанныеСертификата");
    УстановитьПривилегированныйРежим(Ложь);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
	
	Возврат Адрес;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииРеквизита()
	
    Если ЗначениеЗаполнено(Запись.УчетнаяСистема) И Запись.УчетнаяСистема = Источник Тогда
        Записать();
    КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 