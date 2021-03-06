﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Проверки = Новый Структура("КорректностьПериода", Истина);
	БухгалтерскиеОтчетыВызовСервераОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, Проверки);
	
КонецПроцедуры


#КонецЕсли

Процедура БухгалтерскиеОтчетыВызовСервераОбработкаПроверкиЗаполнения(ОтчетОбъект, Отказ, Проверки = Неопределено) Экспорт
	
	Если Проверки = Неопределено Тогда
		Проверки = Новый Структура("КорректностьПериода, ВыборПоказателя", Истина, Истина);
	КонецЕсли;
	
	Если Проверки.Свойство("КорректностьПериода") И Проверки.КорректностьПериода Тогда
		Если ЗначениеЗаполнено(ОтчетОбъект.КонецПериода) И ОтчетОбъект.НачалоПериода > ОтчетОбъект.КонецПериода Тогда
			ТекстСообщения = НСтр("ru = 'Дата начала периода не может быть больше даты конца периода'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Отчет.НачалоПериода",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если Проверки.Свойство("ВыборПоказателя") И Проверки.ВыборПоказателя Тогда
		КоличествоПоказателей = 0;
		ПервыйПоказатель = "";
		НаборПоказателей = Отчеты[ОтчетОбъект.Метаданные().Имя].ПолучитьНаборПоказателей();
		Для Каждого ЭлементНабора Из НаборПоказателей Цикл
			КоличествоПоказателей = КоличествоПоказателей + ОтчетОбъект["Показатель" + ЭлементНабора];
			Если ПустаяСтрока(ПервыйПоказатель) Тогда
				ПервыйПоказатель = "Показатель" + ЭлементНабора;
			КонецЕсли;
		КонецЦикла;
		
		Если КоличествоПоказателей = 0 И НаборПоказателей.Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не выбран показатель(и)'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Отчет." + ПервыйПоказатель,, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция СведенияОВнешнейОбработке() Экспорт
	// Объявим переменную, в которой мы сохраним и вернем "наружу" необходимые данные
    ПараметрыРегистрации = Новый Структура;

    // Объявим еще одну переменную, которая нам потребуется ниже
    МассивНазначений = Новый Массив;
    
    // Первый параметр, который мы должны указать - это какой вид обработки системе должна зарегистрировать. 
    // Допустимые типы: ДополнительнаяОбработка, ДополнительныйОтчет, ЗаполнениеОбъекта, Отчет, ПечатнаяФорма, СозданиеСвязанныхОбъектов
    ПараметрыРегистрации.Вставить("Вид", "ДополнительныйОтчет");

    // Теперь нам необходимо передать в виде массива имен, к чему будет подключена наша ВПФ
    // Имейте ввиду, что можно задать имя в таком виде: Документ.* - в этом случае обработка будет подключена ко всем документам в системе, 
    // которые поддерживают механизм ВПФ
    //МассивНазначений.Добавить("Документ.ЗаказКлиента");
    //ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
    
    // Теперь зададим имя, под которым ВПФ будет зарегистрирована в справочнике внешних обработок
    ПараметрыРегистрации.Вставить("Наименование", "Универсальный отчет");
    
    // Зададим право обработке на использование безопасного режима. Более подробно можно узнать в справке к платформе (метод УстановитьБезопасныйРежим)
    ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);

    // Следующие два параметра играют больше информационную роль, т.е. это то, что будет видеть пользователь в информации к обработке
    ПараметрыРегистрации.Вставить("Версия", "1.11");    
    ПараметрыРегистрации.Вставить("Информация", "Универсальный отчет");
    
    // Создадим таблицу команд (подробнее смотрим ниже)
    ТаблицаКоманд = ПолучитьТаблицуКоманд();
    
    // Добавим команду в таблицу
    ДобавитьКоманду(ТаблицаКоманд, "Универсальный отчет", "УниверсальныйОтчетПоМетаданным", "ОткрытиеФормы", , "");
    
    // Сохраним таблицу команд в параметры регистрации обработки
    ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
    
    // Теперь вернем системе наши параметры
    Возврат ПараметрыРегистрации;
КонецФункции

Функция ПолучитьТаблицуКоманд()

   // Создадим пустую таблицу команд и колонки в ней
   Команды = Новый ТаблицаЗначений;

   // Как будет выглядеть описание печатной формы для пользователя
   Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка")); 

   // Имя нашего макета, что бы могли отличить вызванную команду в обработке печати
   Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));

   // Тут задается, как должна вызваться команда обработки
   // Возможные варианты:
   // - ОткрытиеФормы - в этом случае в колонке идентификатор должно быть указано имя формы, которое должна будет открыть система
   // - ВызовКлиентскогоМетода - вызвать клиентскую экспортную процедуру из модуля формы обработки
   // - ВызовСерверногоМетода - вызвать серверную экспортную процедуру из модуля объекта обработки
   Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));

   // Следующий параметр указывает, необходимо ли показывать оповещение при начале и завершению работы обработки. Не имеет смысла при открытии формы
   Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));

   // Для печатной формы должен содержать строку ПечатьMXL 
   Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
   Возврат Команды;
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
  // Добавляем команду в таблицу команд по переданному описанию.
  // Параметры и их значения можно посмотреть в функции ПолучитьТаблицуКоманд
  НоваяКоманда = ТаблицаКоманд.Добавить();
  НоваяКоманда.Представление = Представление;
  НоваяКоманда.Идентификатор = Идентификатор;
  НоваяКоманда.Использование = Использование;
  НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
  НоваяКоманда.Модификатор = Модификатор;

КонецПроцедуры

