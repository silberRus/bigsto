﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ПолучитьМаксимальныйРазмерПередаваемогоФайла();
	
	ОбновитьНастройкиОбновленияСвязанныхРеквизитов();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ИзменитьРасписание" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогНастройкиРасписанияЗавершение", ЭтаФорма);
		
		ДиалогНастройкиРасписания = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
		ДиалогНастройкиРасписания.Показать(ОписаниеОповещения);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ВвестиИмяПользователяИПароль" Тогда
			
		СтандартнаяОбработка = Ложь;
			
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВызовДляПользователяЗаданияОбмена", Истина);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.АвторизацияВ1СДокументооборот",
			ПараметрыФормы,
			ЭтаФорма,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлятьСвязанныеОбъектыАвтоматическиПриИзменении(Элемент)
	
	ОбновитьИспользованиеРегламентногоЗадания(ОбновлятьСвязанныеОбъектыАвтоматически);
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьИнтеграциюС1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресВебСервиса1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСвязанныеДокументы1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПроцессыИЗадачи1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСогласованиеЧерез1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЕжедневныеОтчеты1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектроннуюПочту1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьФайловоеХранилище1СДокументооборотаПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеКорневойПапкиФайлов1СДокументооборотНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверкаПодключенияЗавершение", ЭтаФорма, Элемент);
	ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(
		ОписаниеОповещения,,, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПодключенияЗавершение(Результат, ЭлементФормы) Экспорт
	
	Если Результат = Истина Тогда
		УстановитьКорневуюПапкуФайловДокументооборота(ЭлементФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКорневуюПапкуФайловДокументооборота(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаВыбора", "DMFileFolder");
	ПараметрыФормы.Вставить("Отбор", 			Неопределено);
	ПараметрыФормы.Вставить("ВыбранныйЭлемент", НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот);
	ПараметрыФормы.Вставить("Заголовок", 		НСтр("ru = 'Выбор папки файлов'"));
	
	Оповещение = Новый ОписаниеОповещения("УстановитьКорневуюПапкуФайловДокументооборотаЗавершение", ЭтаФорма, Элемент);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ВыборИзСписка", 
		ПараметрыФормы, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеКорневойПапкиФайлов1СДокументооборотОчистка(Элемент, СтандартнаяОбработка)
	НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот = "";
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборотПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнтегрируемыеОбъекты(Команда)
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ИнтегрируемыеОбъекты",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилаИнтеграции(Команда)
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДиалогНастройкиРасписанияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОбновитьНастройкиОбновленияСвязанныхРеквизитов(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиОбновленияСвязанныхРеквизитов(Расписание = Неопределено)
	
	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		Элементы.ГруппаАвтообновление.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	Задание = РегламентныеЗаданияСервер.Задание(
		Метаданные.РегламентныеЗадания.ИнтеграцияС1СДокументооборотВыполнитьОбменДанными);
	Если Расписание <> Неопределено Тогда
		Задание.Расписание = Расписание;
		Задание.Записать();
	КонецЕсли;
	
	ОбновлятьСвязанныеОбъектыАвтоматически = Задание.Использование;
	РасписаниеРегламентногоЗадания = Задание.Расписание;
	
	МассивСтрок = Новый Массив;
	
	РасписаниеСтрокой = Строка(Задание.Расписание);
	Если Не СтрЗаканчиваетсяНа(РасписаниеСтрокой, ".") Тогда
		РасписаниеСтрокой = РасписаниеСтрокой + ".  ";
	Иначе
		РасписаниеСтрокой = РасписаниеСтрокой + "  ";
	КонецЕсли;
	МассивСтрок.Добавить(РасписаниеСтрокой);
	
	СтрокаСсылки = Новый ФорматированнаяСтрока(НСтр("ru = 'Изменить расписание'"),,,, "ИзменитьРасписание");
	МассивСтрок.Добавить(СтрокаСсылки);
	
	МассивСтрок.Добавить("  ");
	
	СтрокаСсылки = Новый ФорматированнаяСтрока(НСтр("ru = 'Ввести имя пользователя и пароль'"),,,, "ВвестиИмяПользователяИПароль");
	МассивСтрок.Добавить(СтрокаСсылки);
	
	ОписаниеНастройкиОбновления = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

#Область Клиент

&НаКлиенте
Процедура НаименованиеКорневойПапкиФайлов1СДокументооборотНачалоВыбораЗавершение(Результат, Элемент) Экспорт
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКорневуюПапкуФайловДокументооборотаЗавершение(Результат, Элемент) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда 
		НаборКонстант.НаименованиеКорневойПапкиФайлов1СДокументооборот  = Результат.РеквизитПредставление;
		НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот = Результат.РеквизитID;
	КонецЕсли;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	Если КонстантаИмя = "ИспользоватьИнтеграциюС1СДокументооборот" Тогда
		ОбновитьНастройкиОбновленияСвязанныхРеквизитов();
	КонецЕсли;
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, ПеречитыватьФорму = Истина)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот" Тогда
			НаборКонстант.МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот =
				МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот * (1024*1024);
			КонстантаИмя = "МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот";
		КонецЕсли;
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) 
			И ПеречитыватьФорму Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаименованиеКорневойПапкиФайлов1СДокументооборот" Тогда
		КонстантаИмя = СохранитьЗначениеРеквизита("НаборКонстант.ИдентификаторКорневойПапкиФайлов1СДокументооборот");
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот;
		
		Элементы.АдресВебСервиса1СДокументооборот.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьПроцессыИЗадачи1СДокументооборота.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьСогласованиеЧерез1СДокументооборот.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьСвязанныеДокументы1СДокументооборота.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьЕжедневныеОтчеты1СДокументооборота.Доступность = ЗначениеКонстанты;
		Элементы.ИспользоватьЭлектроннуюПочту1СДокументооборота.Доступность = ЗначениеКонстанты;
		Элементы.МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот.Доступность = ЗначениеКонстанты;
		Элементы.ИнтегрируемыеОбъекты.Доступность = ЗначениеКонстанты;
		Элементы.ПравилаИнтеграции.Доступность = ЗначениеКонстанты;
		
		Элементы.ОбновлятьСвязанныеОбъектыАвтоматически.Доступность = ЗначениеКонстанты;
		Элементы.ОписаниеНастройкиОбновления.Доступность = ЗначениеКонстанты;
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота;
		Элементы.НаименованиеКорневойПапкиФайлов1СДокументооборот.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьФайловоеХранилище1СДокументооборота;
		Элементы.НаименованиеКорневойПапкиФайлов1СДокументооборот.Доступность 	  = ЗначениеКонстанты;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьИспользованиеРегламентногоЗадания(Использование)
	
	Задание = РегламентныеЗаданияСервер.Задание(
		Метаданные.РегламентныеЗадания.ИнтеграцияС1СДокументооборотВыполнитьОбменДанными);
	Задание.Использование = Использование;
	Задание.Записать();
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаСервере
Процедура ПолучитьМаксимальныйРазмерПередаваемогоФайла()
	
	МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот =
		НаборКонстант.МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот / (1024*1024);
	
	Если МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот = 0 Тогда
		МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот = 10; // мб
		СохранитьЗначениеРеквизита("МаксимальныйРазмерФайлаДляПередачиВ1СДокументооборот");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЕстьПодчиненныеКонстанты(ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты)
	
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотПереопределяемый.ПолучитьТаблицуЗависимостиКонстант();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура(
			"ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты",
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты));
	
	Возврат ПодчиненныеКонстанты.Количество() > 0;
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруРодительскихКонстант(СтруктураПодчиненныхКонстант)
	
	Результат 		= Новый Структура;
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотПереопределяемый.ПолучитьТаблицуЗависимостиКонстант();
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
			 ИЛИ СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = ПолучитьСтруктуруРодительскихКонстант(Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты));
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруПодчиненныхКонстант(ИмяРодительскойКонстанты)
	
	Результат 		= Новый Структура;
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотПереопределяемый.ПолучитьТаблицуЗависимостиКонстант();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура("ИмяРодительскойКонстанты", ИмяРодительскойКонстанты));
	
	Для Каждого СтрокаПодчиненного Из ПодчиненныеКонстанты Цикл
		
		Если Результат.Свойство(СтрокаПодчиненного.ИмяПодчиненнойКонстанты) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		ПодчиненныеПодчиненных = ПолучитьСтруктуруПодчиненныхКонстант(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		Для Каждого ПодчиненныйПодчиненного Из ПодчиненныеПодчиненных Цикл
			Результат.Вставить(ПодчиненныйПодчиненного.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
