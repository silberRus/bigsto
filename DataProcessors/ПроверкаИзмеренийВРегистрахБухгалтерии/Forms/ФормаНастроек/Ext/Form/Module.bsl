﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Настройки = ПолучитьИзВременногоХранилища(Параметры.Настройки);
	ИспользоватьВсеРегистры = Настройки.ВыбранныеРегистры.Количество() = 0;
	Элементы.ВыбранныеРегистры.ТолькоПросмотр = ИспользоватьВсеРегистры;
	Для Каждого Регистр Из Метаданные.РегистрыБухгалтерии Цикл
		
		Выбран = ИспользоватьВсеРегистры Или Настройки.ВыбранныеРегистры.Найти(Регистр.Имя) <> Неопределено;
		ВыбранныеРегистры.Добавить(Регистр.Имя, Регистр.Синоним, Выбран);
		
	КонецЦикла;
	
	ИмяКонфигурации = Метаданные.Имя;
	ВерсияКонфигурации = Метаданные.Версия;
	
	Исправлять = Параметры.Исправлять;
	
	ВременныеДанные = Параметры.ВременныеДанные;
	УстановитьСостояние(Не ПустаяСтрока(ВременныеДанные));
	
	ТребуетсяОбновлениеСхемыXDTO = Не Обработки.ПроверкаИзмеренийВРегистрахБухгалтерии.ПроверкаСхемыXDTO();
	ДоступнаВыгрузкаЗагрузка = ПроверкаИКорректировкаДанных.ВнедренаБСП() И ПроверкаИКорректировкаДанных.Модуль("ОбщегоНазначения").ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаДанных");
	
	Элементы.ФормаСохранить.Доступность = Не ТребуетсяОбновлениеСхемыXDTO;
	Элементы.ДекорацияПредупреждение.Видимость = ТребуетсяОбновлениеСхемыXDTO;
	Элементы.ДекорацияЗагрузить.Доступность = Не ТребуетсяОбновлениеСхемыXDTO И ДоступнаВыгрузкаЗагрузка;
	Элементы.ДекорацияОтсутствуетПоддержка.Видимость = Не ДоступнаВыгрузкаЗагрузка;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИдентификаторВладельца = ВладелецФормы.УникальныйИдентификатор;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ЕстьВыбранные = ИспользоватьВсеРегистры;
	Если Не ЕстьВыбранные Тогда
		Для Каждого ЭлементСписка Из ВыбранныеРегистры Цикл
			Если ЭлементСписка.Пометка Тогда
				ЕстьВыбранные = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не ЕстьВыбранные Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = '""Не выбрано ни одного регистра""'");
		Сообщение.Поле = "ВыбранныеРегистры";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Если Исправлять И ПустаяСтрока(ВременныеДанные) Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = '""Для исправления требуется указать эталонные данные""'");
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИспользоватьВсеРегистрыПриИзменении(Элемент)
	
	Если ИспользоватьВсеРегистры Тогда
		ВыбранныеРегистры.ЗаполнитьПометки(Истина);
	КонецЕсли;
	Элементы.ВыбранныеРегистры.ТолькоПросмотр = ИспользоватьВсеРегистры;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗагрузитьНажатие(Элемент)
	
	#Если ВебКлиент Тогда
		
	ЗагрузитьНаВебКлиенте();
		
	#Иначе 
		
	ЗагрузитьНаКлиенте();
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Регистры = Новый Массив;
	Если Не ИспользоватьВсеРегистры Тогда
		Для Каждого ЗначениеСписка Из ВыбранныеРегистры Цикл
			Если ЗначениеСписка.Пометка Тогда
				Регистры.Добавить(ЗначениеСписка.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("ВыбранныеРегистры", Регистры);
	
	Настройки = ПоместитьВоВременноеХранилище(ПараметрыОбработки, ИдентификаторВладельца);
	
	Закрыть(Новый Структура("Настройки, ВременныеДанные", Настройки, ВременныеДанные));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСостояние(ДанныеЗагружены)
	
	Если ДанныеЗагружены Тогда
		Элементы.ДекорацияЗагрузить.Заголовок = НСтр("ru = 'Данные уже загружены, загрузить data_dump.zip'");
	Иначе
		Элементы.ДекорацияЗагрузить.Заголовок = НСтр("ru = 'Загрузить data_dump.zip'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьДанныеРегистровБухгалтерии(ИмяВременногоКаталога, ИмяФайлаАрхива, ИмяКонфигурации, ВерсияКонфигурации)
	
	#Если Не ВебКлиент Тогда
	
	ЧтениеZipФайла = Новый ЧтениеZipФайла(ИмяФайлаАрхива);
	ЭлементZipФайла = ЧтениеZipФайла.Элементы.Найти("DumpInfo.xml");
	Если ЭлементZipФайла = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Неправильный формат файла, не найден файл DumpInfo.xml.'");		
	КонецЕсли;
	ЧтениеZipФайла.Извлечь(ЭлементZipФайла , ИмяВременногоКаталога, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяВременногоКаталога + ПолучитьРазделительПути() + "DumpInfo.xml");
	ИнфоXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	ЭлементZipФайла = ЧтениеZipФайла.Элементы.Найти("PackageContents.xml");
	Если ЭлементZipФайла = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Неправильный формат файла, не найден файл PackageContents.xml.'");		
	КонецЕсли;
	ЧтениеZipФайла.Извлечь(ЭлементZipФайла , ИмяВременногоКаталога, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяВременногоКаталога + ПолучитьРазделительПути() + "PackageContents.xml");
	КонтентXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	ЧтениеXML.Закрыть();
	
	ДанныеРегистров = Новый Структура;
	
	Для Каждого Файл Из КонтентXDTO.File Цикл
		
		Если Файл.Type = "InfobaseData" И СтрНачинаетсяС(Файл.DataType, "РегистрБухгалтерии.") Тогда
			
			ИмяРегистра = Сред(Файл.DataType, СтрНайти(Файл.DataType, ".") + 1);
			ЭлементZipФайла = ЧтениеZipФайла.Элементы.Найти(Файл.Name);
			Если ЭлементZipФайла = Неопределено Тогда
				ВызватьИсключение НСтр("ru = 'Неправильный формат файла, не найден файл регистра бухгалтерии.'");		
			КонецЕсли;
			ЧтениеZipФайла.Извлечь(ЭлементZipФайла , ИмяВременногоКаталога, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
			
			ИмяФайла = ИмяВременногоКаталога + ПолучитьРазделительПути() + Файл.Name;
			#Если Клиент Тогда
				ДанныеРегистров.Вставить(ИмяРегистра, ИмяФайла);
			#Иначе
				ДанныеРегистра = Новый ХранилищеЗначения(Новый ДвоичныеДанные(ИмяФайла), Новый СжатиеДанных(9));
				ДанныеРегистров.Вставить(ИмяРегистра, ДанныеРегистра);
			#КонецЕсли
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеРегистров;
	
	#КонецЕсли
	
КонецФункции

#Область ЗагрузкаНаВебКлиенте

#Если ВебКлиент Тогда

&НаКлиенте
Процедура ЗагрузитьНаВебКлиенте()
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеПомещенияФайлаНаВебКлиенте", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение, , "*.zip", Истина, ВладелецФормы.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПомещенияФайлаНаВебКлиенте(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьДанныеРегистровБухгалтерииНаСервере(Адрес);
	
КонецПроцедуры

#КонецЕсли

&НаСервере
Процедура ПолучитьДанныеРегистровБухгалтерииНаСервере(Адрес)
	
	ИмяФайла = ПолучитьИмяВременногоФайла("zip");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ДвоичныеДанные.Записать(ИмяФайла);
	УдалитьИзВременногоХранилища(Адрес);
	
	ИмяВременногоКаталога = КаталогВременныхФайлов() + Новый УникальныйИдентификатор;
	СоздатьКаталог(ИмяВременногоКаталога);
	
	Попытка
		ДанныеРегистров = ПолучитьДанныеРегистровБухгалтерии(ИмяВременногоКаталога, ИмяФайла, ИмяКонфигурации, ВерсияКонфигурации);
	Исключение
		УдалитьФайлы(ИмяФайла);
		УдалитьФайлы(ИмяВременногоКаталога);
		ВызватьИсключение;
	КонецПопытки;
	
	Если ДанныеРегистров.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Файлы регистров бухгалтерии не найдены.'");
		Сообщение.Сообщить();
	Иначе	
		ВременныеДанные = ПоместитьВоВременноеХранилище(ДанныеРегистров, ИдентификаторВладельца);
		УстановитьСостояние(Истина);
	КонецЕсли;
	
	УдалитьФайлы(ИмяФайла);
	УдалитьФайлы(ИмяВременногоКаталога);
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаНаКлиенте

&НаКлиенте
Процедура ЗагрузитьНаКлиенте()
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораФайла", ЭтотОбъект);
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр = "Файл архива(*.zip)";
	ДиалогВыбораФайла.Показать(Оповещение);
	
КонецПроцедуры

#Если Не ВебКлиент Тогда
	
&НаКлиенте
Процедура ЗавершениеВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяВременногоКаталога = КаталогВременныхФайлов() + Новый УникальныйИдентификатор;
	СоздатьКаталог(ИмяВременногоКаталога);
	
	Попытка
		ДанныеРегистров = ПолучитьДанныеРегистровБухгалтерии(ИмяВременногоКаталога, ВыбранныеФайлы[0], ИмяКонфигурации, ВерсияКонфигурации);
	Исключение
		УдалитьФайлы(ИмяВременногоКаталога);
		ВызватьИсключение;
	КонецПопытки;
	
	Если ДанныеРегистров.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Файлы регистров бухгалтерии не найдены.'");
		Сообщение.Сообщить();
		УдалитьФайлы(ИмяВременногоКаталога);
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ИмяВременногоКаталога", ИмяВременногоКаталога);
	ДополнительныеПараметры.Вставить("ДанныеРегистров", ДанныеРегистров);
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеПомещенияФайлов", ЭтотОбъект, ДополнительныеПараметры);
	ПомещаемыеФайлы = Новый Массив;
	Для Каждого ДанныеРегистра Из ДанныеРегистров Цикл
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДанныеРегистра.Значение));
	КонецЦикла;
	
	НачатьПомещениеФайлов(Оповещение, ПомещаемыеФайлы, , Ложь, ВладелецФормы.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	УдалитьФайлы(ДополнительныеПараметры.ИмяВременногоКаталога);
	ЗавершениеПомещенияФайловНаСервере(ПомещенныеФайлы, ДополнительныеПараметры.ДанныеРегистров);
	
КонецПроцедуры

#КонецЕсли

&НаСервере
Процедура ЗавершениеПомещенияФайловНаСервере(ПомещенныеФайлы, ДанныеРегистров)
	
	Для Каждого ПомещенныйФайл Из ПомещенныеФайлы Цикл
		Для Каждого ДанныеРегистра Из ДанныеРегистров Цикл
			Если ПомещенныйФайл.Имя = ДанныеРегистра.Значение Тогда
				ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение);
				ДанныеРегистров.Вставить(ДанныеРегистра.Ключ, Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9)));
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ВременныеДанные = ПоместитьВоВременноеХранилище(ДанныеРегистров, ИдентификаторВладельца);
	
	УстановитьСостояние(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти