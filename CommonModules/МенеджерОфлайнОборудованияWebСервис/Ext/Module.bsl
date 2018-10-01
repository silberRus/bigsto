﻿
#Область ПрограммныйИнтерфейсСлужебный

// Метод Connect Web-сервиса EquipmentService.
//
Функция Соединиться(ИДУстройства) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ВидТранспортаОфлайнОбмена = ЗНАЧЕНИЕ(Перечисление.ВидыТранспортаОфлайнОбмена.WS)
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторСервисОборудования";
	
	Запрос.УстановитьПараметр("ИдентификаторСервисОборудования", ИДУстройства);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Метод GetSettings Web-сервиса EquipmentService.
//
Функция ПолучитьНастройки(ИДУстройства) Экспорт
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
	
	НастройкиККМ = МенеджерОфлайнОборудования.ПолучитьНастройкиККМ();
	ЗаполнитьНастройкиККМ(ОфлайнОборудование, НастройкиККМ);
	
	ТекстСообщения = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLНастроек(НастройкиККМ, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
	
	МенеджерОфлайнОборудованияВызовСервера.ОповеститьОбУдачнойВыгрузке(ОфлайнОборудование, Новый Структура("Настройки", Истина));
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод GetPriceList Web-сервиса EquipmentService.
//
Функция ПолучитьПрайсЛист(ИДУстройства) Экспорт
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
	
	ПрайсЛистККМ = МенеджерОфлайнОборудования.ПолучитьПрайсЛистККМ();
	ЗаполнитьПрайсЛист(ОфлайнОборудование, ПрайсЛистККМ);
	
	ТекстСообщения = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLПрайсЛиста(ПрайсЛистККМ, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
	
	МенеджерОфлайнОборудованияВызовСервера.ОповеститьОбУдачнойВыгрузке(ОфлайнОборудование, Новый Структура("ПрайсЛист", Истина));
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод GetDocs Web-сервиса EquipmentService.
//
Функция ПолучитьДокументы(ИДУстройства, ТипДокумента) Экспорт
	
	Если ТипДокумента = "Order" Тогда
		
		ЗаказыККМ = МенеджерОфлайнОборудования.ПолучитьЗаказыККМ();
		
		ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
		ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
		
		ЗаполнитьЗаказы(ОфлайнОборудование, ЗаказыККМ);
		
		ТекстСообщения = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLЗаказов(ЗаказыККМ, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
		
		МенеджерОфлайнОборудованияВызовСервера.ОповеститьОбУдачнойВыгрузке(ОфлайнОборудование, Новый Структура("Заказы", Истина));
		
		Возврат ТекстСообщения;
		
	КонецЕсли;
	
КонецФункции

// Метод GetGood Web-сервиса EquipmentService
Функция ПолучитьТовар(ИДУстройства, Штрихкод) Экспорт
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
	
	ПрайсЛистККМ = МенеджерОфлайнОборудования.ПолучитьПрайсЛистККМ();
	ЗаполнитьПрайсЛистПоШтрихкоду(ОфлайнОборудование, ПрайсЛистККМ, Штрихкод);
	
	ТекстСообщения = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLПрайсЛиста(ПрайсЛистККМ, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод PreparePriceList Web-сервиса EquipmentService.
//
Функция ПолучитьИдентификаторПередачиПрайсЛиста(ИДУстройства) Экспорт
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	
	ИдентификаторПередачи = ПолучитьНеотправленныйИдентификаторИзОчередиСообщений(ОфлайнОборудование);
	
	Если ИдентификаторПередачи = Неопределено Тогда
		ИдентификаторПередачи = Строка(Новый УникальныйИдентификатор);
		ЗапуститьФормированиеОчередиСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи);
	КонецЕсли;
	
	Возврат ИдентификаторПередачи;
	
КонецФункции

// Метод GetPriceListPackage Web-сервиса EquipmentService.
//
Функция ПолучитьПакетПрайсЛиста(ИДУстройства, ИдентификаторПередачи, Рестарт) Экспорт
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	
	СтруктураОтвета = ПолучитьОтветПриВыгрузкеПакетаПрайсЛиста();
	
	СтруктураСообщения = ПолучитьСообщениеИзОчередиОбмена(ОфлайнОборудование, ИдентификаторПередачи, Рестарт);
	
	Если СтруктураСообщения = Неопределено Тогда
		
		СтруктураОтвета.Успешно = Ложь; // Пакет еще не готов
		
	Иначе
		
		ПометитьСообщениеОбменаВОчередиКакОтправленное(СтруктураСообщения);
		СтруктураОтвета.Успешно  = Истина;
		СтруктураОтвета.ПакетПрайсЛиста = СтруктураСообщения.ДанныеПакета.Получить();
		СтруктураОтвета.НомерПакета = СтруктураСообщения.ПорядковыйНомер;
		СтруктураОтвета.ПакетовВсего = СтруктураСообщения.ПакетовВсего;
		
		Если СтруктураСообщения.ПорядковыйНомер = 1 Тогда
			МенеджерОфлайнОборудованияВызовСервера.ОповеститьОбУдачнойВыгрузке(ОфлайнОборудование, Новый Структура("ПрайсЛист", Истина)); 
		КонецЕсли;
	КонецЕсли;
	
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
	
	ТекстСообщения = СформироватьТекстСообщенияОтветаПолученияПакетаПрайсЛиста(СтруктураОтвета, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод PostDoc Web-сервиса EquipmentService.
//
Функция ЗагрузитьДокумент(ИДУстройства, ТипДокумента, XMLТекст) Экспорт
	
	СтруктураОтвета = ПолучитьОтветПриЗагрузке();
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
	ВерсияФорматаОбмена = ДанныеУстройства.Параметры.ВерсияФорматаОбмена;
	
	Отказ = Ложь;
	СообщениеОбОшибке = "";
	
	Если ТипДокумента = "SaleReports" ИЛИ ТипДокумента = "SalesReport" ИЛИ ТипДокумента = "SaleReport" Тогда
		ЗагрузитьОтчетыОПродажах(ОфлайнОборудование, XMLТекст, ВерсияФорматаОбмена, Отказ, СообщениеОбОшибке);
	КонецЕсли;
	
	Если ТипДокумента = "AlcoholTareOpening" Тогда
		ЗагрузитьВскрытияАлкогольнойТары(ОфлайнОборудование, XMLТекст, ВерсияФорматаОбмена, Отказ, СообщениеОбОшибке);
	КонецЕсли;
	
	Если ТипДокумента = "PriceCheckerReport" Тогда
		ЗагрузитьОтчетПрайсЧекера(ОфлайнОборудование, XMLТекст, ВерсияФорматаОбмена, Отказ, СообщениеОбОшибке);
	КонецЕсли;
	
	Если Отказ Тогда
		
		СтруктураОтвета.Успешно  = Ложь;
		СтруктураОтвета.Описание = СообщениеОбОшибке;
		
	Иначе
		СтруктураОтвета.Успешно  = Истина;
		СтруктураОтвета.Описание = НСтр("ru = 'Данные успешно загружены'");
	КонецЕсли;
	
	ТекстСообщения = СформироватьТекстСообщенияОтветаЗагрузкиДокумента(СтруктураОтвета, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
	
	Возврат ТекстСообщения;
	
КонецФункции

// Метод GetVersion Web-сервиса EquipmentService.
//
Функция ПолучитьВерсиюФорматаОбмена(ИДУстройства) Экспорт
	
	ОфлайнОборудование = ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства);
	
	Если ОфлайнОборудование = Неопределено Тогда
		
		Возврат 0;
	Иначе
		
		ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
		
		Возврат ДанныеУстройства.Параметры.ВерсияФорматаОбмена;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

// Функция возвращает пустую структуру записи ответа PostDocsResponse
// Для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьОтветПриЗагрузке()
	
	СтруктураОтветаПриЗагрузке = Новый Структура;
	
	СтруктураОтветаПриЗагрузке.Вставить("Успешно", Ложь);
	СтруктураОтветаПриЗагрузке.Вставить("Описание", "");
	
	Возврат СтруктураОтветаПриЗагрузке;
	
КонецФункции

Процедура СформироватьОчередьСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи) Экспорт
	
	ОчиститьОчередьСообщенийОбменаЭкземпляраОборудования(ОфлайнОборудование);
	
	ДанныеУстройства = МенеджерОборудованияВызовСервера.ПолучитьДанныеУстройства(ОфлайнОборудование);
	
	ПрайсЛистККМ = МенеджерОфлайнОборудования.ПолучитьПрайсЛистККМ();
	ЗаполнитьПрайсЛист(ОфлайнОборудование, ПрайсЛистККМ);
	
	КоличествоЭлементовВПакете = ПолучитьКоличествоЭлементовВПакете(ОфлайнОборудование);
	
	МассивПакетов = ОфлайнОборудование1СККМВызовСервера.РазбитьПрайсЛистПоПакетам(ПрайсЛистККМ, КоличествоЭлементовВПакете);
	
	Если МассивПакетов.Количество() = 0 Тогда
		
		XMLТекстСообщения = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLПрайсЛиста(ПрайсЛистККМ, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
		ДобавитьПакетДанныхВОчередьСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи, XMLТекстСообщения);
		
	Иначе
		
		ВсегоПакетов = МассивПакетов.Количество();
		Для Каждого Пакет Из МассивПакетов Цикл
			
			XMLТекстСообщения = ОфлайнОборудование1СККМВызовСервера.ПолучитьТекстXMLПрайсЛиста(Пакет, ДанныеУстройства.Параметры.ВерсияФорматаОбмена);
			ДобавитьПакетДанныхВОчередьСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи, XMLТекстСообщения, Пакет.НомерПакета, ВсегоПакетов);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьКоличествоЭлементовВПакете(ОфлайнОборудование)
	
	ПараметрыУстройства = Справочники.ПодключаемоеОборудование.ПолучитьПараметрыУстройства(ОфлайнОборудование);
	
	КоличествоЭлементовВПакете = 0;
	
	Если ПараметрыУстройства.Свойство("КоличествоЭлементовВПакете") Тогда
		
		КоличествоЭлементовВПакете = ПараметрыУстройства.КоличествоЭлементовВПакете;
	КонецЕсли;
	
	Возврат КоличествоЭлементовВПакете;
	
КонецФункции

Процедура ЗапуститьФормированиеОчередиСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи)
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	Если ЭтоФайловаяБаза Тогда
		
		// В файловом варианте сообщение готовится в момент вызова с клиента
		СформироватьОчередьСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи);
		
	Иначе
		// В клиент-серверном варианте сообщения готовятся в фоновом задании.
		
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(ОфлайнОборудование);
		МассивПараметров.Добавить(ИдентификаторПередачи);
		
		ИмяФункции = "МенеджерОфлайнОборудованияWebСервис.СформироватьОчередьСообщенийОбмена";
		
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(
			ИмяФункции,
			МассивПараметров,
			ИдентификаторПередачи,
			ОфлайнОборудование);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьЭкземплярОборудованияПоИдентификатору(ИДУстройства)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.УстройствоИспользуется
	|	И ПодключаемоеОборудование.ВидТранспортаОфлайнОбмена = ЗНАЧЕНИЕ(Перечисление.ВидыТранспортаОфлайнОбмена.WS)
	|	И ПодключаемоеОборудование.ИдентификаторWebСервисОборудования = &ИдентификаторСервисОборудования";
	
	Запрос.УстановитьПараметр("ИдентификаторСервисОборудования", ИДУстройства);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПакетДанныхВОчередьСообщенийОбмена(ОфлайнОборудование, ИдентификаторПередачи, ТекстСообщения, ПорядковыйНомер = 1, ПакетовВсего = 1)
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Отбор.ПорядковыйНомер.Установить(ПорядковыйНомер);
	НаборЗаписей.Прочитать();
	
	// Если сообщение с таким номером уже есть в очереди, генерируем исключение.
	Если НаборЗаписей.Количество() > 0 Тогда
		
		ВызватьИсключение(НСтр("ru='Не удалось выполнить отправку данных. Очередь сообщений обмена уже содержит сообщение с номером" + " " + ПорядковыйНомер + ".'"));
		
	КонецЕсли;
	
	НоваяЗапись 						= НаборЗаписей.Добавить();
	НоваяЗапись.ОфлайнОборудование 		= ОфлайнОборудование;
	НоваяЗапись.ИдентификаторПередачи 	= ИдентификаторПередачи;
	НоваяЗапись.ПорядковыйНомер 		= ПорядковыйНомер;
	НоваяЗапись.ДанныеПакета 			= Новый ХранилищеЗначения(ТекстСообщения, Новый СжатиеДанных(9));
	НоваяЗапись.ПакетовВсего 			= ПакетовВсего;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Процедура ОчиститьОчередьСообщенийОбменаЭкземпляраОборудования(ОфлайнОборудование)
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	
	НаборЗаписей.Записать(Истина);

КонецПроцедуры

Функция ПолучитьНеотправленныйИдентификаторИзОчередиСообщений(ОфлайнОборудование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ОчередьСообщенийОбменаСОфлайнОборудованием.ИдентификаторПередачи КАК ИдентификаторПередачи
		|ИЗ
		|	РегистрСведений.ОчередьСообщенийОбменаСОфлайнОборудованием КАК ОчередьСообщенийОбменаСОфлайнОборудованием
		|ГДЕ
		|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОфлайнОборудование = &ОфлайнОборудование
		|	И НЕ ОчередьСообщенийОбменаСОфлайнОборудованием.Отправлен";
	
	Запрос.УстановитьПараметр("ОфлайнОборудование", ОфлайнОборудование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ИдентификаторПередачи;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьСообщениеИзОчередиОбмена(ОфлайнОборудование, ИдентификаторПередачи, Рестарт)
	
	Если Рестарт Тогда
		СброситьФлагОтправкиВОчередиОбмена(ОфлайнОборудование, ИдентификаторПередачи);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОфлайнОборудование КАК ОфлайнОборудование,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ИдентификаторПередачи,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ПорядковыйНомер,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ДанныеПакета,
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ПакетовВсего
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийОбменаСОфлайнОборудованием КАК ОчередьСообщенийОбменаСОфлайнОборудованием
	|ГДЕ
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ОфлайнОборудование = &ОфлайнОборудование
	|	И НЕ ОчередьСообщенийОбменаСОфлайнОборудованием.Отправлен
	|	И ОчередьСообщенийОбменаСОфлайнОборудованием.ИдентификаторПередачи = &ИдентификаторПередачи
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОчередьСообщенийОбменаСОфлайнОборудованием.ПорядковыйНомер";
	
	Запрос.УстановитьПараметр("ОфлайнОборудование",    ОфлайнОборудование);
	Запрос.УстановитьПараметр("ИдентификаторПередачи", ИдентификаторПередачи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураПакета = Новый Структура;
		СтруктураПакета.Вставить("ОфлайнОборудование", 		Выборка.ОфлайнОборудование);
		СтруктураПакета.Вставить("ИдентификаторПередачи", 	Выборка.ИдентификаторПередачи);
		СтруктураПакета.Вставить("ПорядковыйНомер", 		Выборка.ПорядковыйНомер);
		СтруктураПакета.Вставить("ДанныеПакета", 			Выборка.ДанныеПакета);
		СтруктураПакета.Вставить("ПакетовВсего", 			Выборка.ПакетовВсего);
		
		Возврат СтруктураПакета;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ПометитьСообщениеОбменаВОчередиКакОтправленное(СтруктураСообщения)
	
	МенеджерЗаписи = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ОфлайнОборудование = СтруктураСообщения.ОфлайнОборудование;
	МенеджерЗаписи.ИдентификаторПередачи = СтруктураСообщения.ИдентификаторПередачи;
	
	МенеджерЗаписи.Прочитать();
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураСообщения);
	
	МенеджерЗаписи.Отправлен = Истина;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

Процедура СброситьФлагОтправкиВОчередиОбмена(ОфлайнОборудование, ИдентификаторПередачи);
	
	НаборЗаписей = РегистрыСведений.ОчередьСообщенийОбменаСОфлайнОборудованием.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОфлайнОборудование.Установить(ОфлайнОборудование);
	НаборЗаписей.Отбор.ИдентификаторПередачи.Установить(ИдентификаторПередачи);
	НаборЗаписей.Прочитать();
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.Отправлен = Ложь;
	КонецЦикла;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

Функция СформироватьТекстСообщенияОтветаЗагрузкиДокумента(СтруктураОтвета, ВерсияФорматаОбмена)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	URIИмен = ОфлайнОборудование1СККМВызовСервера.URIПространстваИмен(ВерсияФорматаОбмена);
	
	Если ВерсияФорматаОбмена >= 1006 Тогда
		ТипОбъекта = ФабрикаXDTO.Тип(URIИмен, "PostDocsResponse");
	Иначе
		ТипОбъекта = ФабрикаXDTO.Тип(URIИмен, "Response");
	КонецЕсли;
	
	ОбъектОбмена = ФабрикаXDTO.Создать(ТипОбъекта);
	ОбъектОбмена.Успешно = СтруктураОтвета.Успешно;
	
	Если ЗначениеЗаполнено(СтруктураОтвета.Описание) Тогда
		
		ОбъектОбмена.Описание = СтруктураОтвета.Описание;
	КонецЕсли;
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектОбмена);
	ТекстСообщения = ЗаписьXML.Закрыть();
	
	Возврат ТекстСообщения;
	
КонецФункции

Функция СформироватьТекстСообщенияОтветаПолученияПакетаПрайсЛиста(СтруктураОтвета, ВерсияФорматаОбмена)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	URIИмен      = ОфлайнОборудование1СККМВызовСервера.URIПространстваИмен(ВерсияФорматаОбмена);
	
	ТипОбъекта   = ФабрикаXDTO.Тип(URIИмен, "PriceListPackage");
	
	ОбъектОбмена = ФабрикаXDTO.Создать(ТипОбъекта);
	ОбъектОбмена.Успешно = СтруктураОтвета.Успешно;
	
	Если ЗначениеЗаполнено(СтруктураОтвета.ПакетПрайсЛиста) Тогда
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(СтруктураОтвета.ПакетПрайсЛиста);
		ТипОбъектаПрайсЛист   = ФабрикаXDTO.Тип(URIИмен, "PriceList");
		ДанныеПрайсЛист = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъектаПрайсЛист);
		ЧтениеXML.Закрыть();
		ОбъектОбмена.ПрайсЛист = ДанныеПрайсЛист;
	КонецЕсли;
	
	Если НЕ ОбъектОбмена.Свойства().Получить("НомерПакета") = Неопределено Тогда
		ОбъектОбмена.НомерПакета = СтруктураОтвета.НомерПакета;
	КонецЕсли;
	
	Если НЕ ОбъектОбмена.Свойства().Получить("ПакетовВсего") = Неопределено Тогда
		ОбъектОбмена.ПакетовВсего = СтруктураОтвета.ПакетовВсего;
	КонецЕсли;
	
	ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, ОбъектОбмена);
	ТекстСообщения = ЗаписьXML.Закрыть();
	
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ЗаполнитьНастройкиККМ(ОфлайнОборудование, Настройки)
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеНастроек(ОфлайнОборудование, Настройки);
	
	ПараметрыУстройства = Справочники.ПодключаемоеОборудование.ПолучитьПараметрыУстройства(ОфлайнОборудование);
	
	Если ПараметрыУстройства.Свойство("ПараметрыДрайвераККМ") И НЕ ПараметрыУстройства.ПараметрыДрайвераККМ = Неопределено Тогда
		
		Настройки.Вставить("ПараметрыДрайвераККМ", ПараметрыУстройства.ПараметрыДрайвераККМ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПрайсЛист(ОфлайнОборудование, ПрайсЛистККМ)
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеПрайсЛиста(ОфлайнОборудование, ПрайсЛистККМ, Ложь);
	ПрайсЛистККМ.Вставить("ПолнаяВыгрузка", Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьПрайсЛистПоШтрихкоду(ОфлайнОборудование, ПрайсЛистККМ, Штрихкод)
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеТовараПоШтрихкоду(ОфлайнОборудование, ПрайсЛистККМ, Штрихкод);
	ПрайсЛистККМ.Вставить("ПолнаяВыгрузка", Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьЗаказы(ОфлайнОборудование, ЗаказыККМ)
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриВыгрузкеЗаказов(ОфлайнОборудование, ЗаказыККМ);
	
КонецПроцедуры

Процедура ЗагрузитьОтчетыОПродажах(ОфлайнОборудование, XMLТекст, ВерсияФорматаОбмена, Отказ, СообщениеОбОшибке)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLТекст);
	
	Фабрика = ОфлайнОборудование1СККМВызовСервера.ПолучитьФабрикуXDTO(ВерсияФорматаОбмена);
	
	Если ВерсияФорматаОбмена > 2000 Тогда
		ИмяТипа = "SaleReports";
	Иначе
		ИмяТипа = "SalesReports";
	КонецЕсли;
	
	ТипXDTO = Фабрика.Тип(ОфлайнОборудование1СККМВызовСервера.URIПространстваИмен(ВерсияФорматаОбмена), ИмяТипа);
	
	Попытка
		ДанныеXDTO = Фабрика.ПрочитатьXML(ЧтениеXML, ТипXDTO);
		ЧтениеXML.Закрыть();
	Исключение
		
		ТекстСообщения = НСтр("ru='При чтении файла-отчета произошла ошибка. Формат отчета не соответствует версии формата обмена.'")
		+ Символы.ПС + ОписаниеОшибки();
		
		Отказ = Истина;
		СообщениеОбОшибке = ТекстСообщения;
		
		ЧтениеXML.Закрыть();
		Возврат;
	КонецПопытки;
	
	ЗагружаемыеДанныеИзККМ = МенеджерОфлайнОборудования.ПолучитьЗагружаемыеДанныеИзККМ();
	
	Если ВерсияФорматаОбмена > 2000 Тогда
		ОфлайнОборудование1СККМВызовСервера.ЗаполнитьОтчетыОПродажах(ДанныеXDTO, ЗагружаемыеДанныеИзККМ.ОтчетыОПродажах, ВерсияФорматаОбмена);
	Иначе
		ОфлайнОборудование1СККМВызовСервера.ЗаполнитьОтчетыОПродажах1000(ДанныеXDTO, ЗагружаемыеДанныеИзККМ.ОтчетыОПродажах, ВерсияФорматаОбмена);
	КонецЕсли;
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриЗагрузкеДанныхОПродажахИзККМ(
		ОфлайнОборудование,
		ЗагружаемыеДанныеИзККМ.ОтчетыОПродажах,
		Отказ,
		СообщениеОбОшибке
	);
	
КонецПроцедуры

Процедура ЗагрузитьВскрытияАлкогольнойТары(ОфлайнОборудование, XMLТекст, ВерсияФорматаОбмена, Отказ, СообщениеОбОшибке)
	
	Если НЕ ВерсияФорматаОбмена > 2000 Тогда
		Отказ = Истина;
		СообщениеОбОшибке = НСтр("ru='Формат %ВерсияФормата% не поддерживает загрузку вскрытий алкогольной тары'");
	КонецЕсли;
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLТекст);
	
	Фабрика = ОфлайнОборудование1СККМВызовСервера.ПолучитьФабрикуXDTO(ВерсияФорматаОбмена);
	
	ИмяТипа = "AlcoholTareOpenings";
	
	ТипXDTO = Фабрика.Тип(ОфлайнОборудование1СККМВызовСервера.URIПространстваИмен(ВерсияФорматаОбмена), ИмяТипа);
	
	Попытка
		ДанныеXDTO = Фабрика.ПрочитатьXML(ЧтениеXML, ТипXDTO);
		ЧтениеXML.Закрыть();
	Исключение
		
		ТекстСообщения = НСтр("ru='При чтении файла произошла ошибка'")
		+ Символы.ПС + ОписаниеОшибки();
		
		Отказ = Истина;
		СообщениеОбОшибке = ТекстСообщения;
		
		ЧтениеXML.Закрыть();
		Возврат;
	КонецПопытки;
	
	ЗагружаемыеДанныеИзККМ = МенеджерОфлайнОборудования.ПолучитьЗагружаемыеДанныеИзККМ();
	
	ОфлайнОборудование1СККМВызовСервера.ЗаполнитьОтчетыВскрытияТары(ДанныеXDTO, ЗагружаемыеДанныеИзККМ.ВскрытияАлкогольнойТары, ВерсияФорматаОбмена);
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриЗагрузкеДанныхОВскрытияхАлкогольнойТарыИзККМ(
		ОфлайнОборудование,
		ЗагружаемыеДанныеИзККМ.ВскрытияАлкогольнойТары,
		Отказ,
		СообщениеОбОшибке
	);
	
КонецПроцедуры

Процедура ЗагрузитьОтчетПрайсЧекера(ОфлайнОборудование, XMLТекст, ВерсияФорматаОбмена, Отказ, СообщениеОбОшибке)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLТекст);
	
	Фабрика = ОфлайнОборудование1СККМВызовСервера.ПолучитьФабрикуXDTO(ВерсияФорматаОбмена);
	
	Если ВерсияФорматаОбмена > 2000 Тогда
		ИмяТипа = "PriceCheckerReports";
	Иначе
		ИмяТипа = "PriceCheckerReport";
	КонецЕсли;
	
	ТипXDTO = Фабрика.Тип(ОфлайнОборудование1СККМВызовСервера.URIПространстваИмен(ВерсияФорматаОбмена), ИмяТипа);
	
	Попытка
		ДанныеXDTO = Фабрика.ПрочитатьXML(ЧтениеXML, ТипXDTO);
		ЧтениеXML.Закрыть();
	Исключение
		
		ТекстСообщения = НСтр("ru='При чтении файла произошла ошибка'")
		+ Символы.ПС + ОписаниеОшибки();
		
		Отказ = Истина;
		СообщениеОбОшибке = ТекстСообщения;
		
		ЧтениеXML.Закрыть();
		Возврат;
	КонецПопытки;
	
	ЗагружаемыеДанные = МенеджерОфлайнОборудования.ПолучитьЗагружаемыеДанныеИзПрайсЧекера();
	
	ОфлайнОборудование1СККМВызовСервера.ЗаполнитьОтчетОПроверкахЦен(ДанныеXDTO, ЗагружаемыеДанные.ОтчетыОПроверкахЦенников, ВерсияФорматаОбмена);
	
	МенеджерОфлайнОборудованияПереопределяемый.ПриЗагрузкеДанныхОПроверкахЦенников(
		ОфлайнОборудование,
		ЗагружаемыеДанные.ОтчетыОПроверкахЦенников,
		Отказ,
		СообщениеОбОшибке
	);
	
КонецПроцедуры

Функция ПолучитьОтветПриВыгрузкеПакетаПрайсЛиста()
	
	СтруктураОтветаПриЗагрузке = Новый Структура;
	
	СтруктураОтветаПриЗагрузке.Вставить("Успешно", Ложь);
	СтруктураОтветаПриЗагрузке.Вставить("ПакетПрайсЛиста", "");
	СтруктураОтветаПриЗагрузке.Вставить("НомерПакета", 1);
	СтруктураОтветаПриЗагрузке.Вставить("ПакетовВсего", 1);
	
	Возврат СтруктураОтветаПриЗагрузке;
	
КонецФункции

#КонецОбласти

