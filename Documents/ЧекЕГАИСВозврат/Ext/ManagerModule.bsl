﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДействияПриОбменеЕГАИС

// Статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция);
	
КонецФункции

// Статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки);
	
КонецФункции

// Статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура со свойствами:
//   * СтатусОбработки - Перечисление.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * НовыйСтатус - ПеречисленияСсылка.СтатусыИнформированияЕГАИС - Новый статус.
//   * ДальнейшееДействие1 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 1.
//   * ДальнейшееДействие2 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 2.
//   * ДальнейшееДействие3 - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие 3.
//
Функция СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции


// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки, ДополнительныеПараметры);
	
КонецФункции

// Обновить статус после получения данных из ЕГАИС.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ, для которого требуется обновить статус.
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция обмена с ЕГАИС.
//  ДополнительныеПараметры - Неопределено, Структура со свойствами:
//   * СтатусОбработки - Перечисление.СтатусыОбработкиСообщенийЕГАИС - Статус обработки сообщения.
//   * ОперацияКвитанции - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция, на которую получена квитанция.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияЕГАИС - Новый статус.
//
Функция ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры = Неопределено) Экспорт
	
	Возврат ЧекиЕГАИС.ОбновитьСтатусПослеПолученияДанных(ДокументСсылка, Операция, ДополнительныеПараметры);
	
КонецФункции


// Получить последовательность операций в течении жизненного цикла документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИС - Документ, для которого требуется обновить статус.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - см. функцию ИнтеграцияЕГАИС.ПустаяТаблицаПоследовательностьОпераций().
//
Функция ПоследовательностьОпераций(ДокументСсылка) Экспорт
	
	Возврат ЧекиЕГАИС.ПоследовательностьОпераций(ДокументСсылка);
	
КонецФункции

// Обработчик изменения статуса документа.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.АктПостановкиНаБалансЕГАИС - Документ.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС - Предыдущий статус.
//  ПараметрыОбновленияСтатуса - Структура - см. функцию ИнтеграцияЕГАИС.ПараметрыОбновленияСтатуса().
//
Процедура ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса) Экспорт
	
	ЧекиЕГАИС.ПриИзмененииСтатусаЧекаНаВозврат(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
	ИнтеграцияЕГАИСПереопределяемый.ПриИзмененииСтатусаДокумента(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус, ПараметрыОбновленияСтатуса);
	
	РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус);
	
КонецПроцедуры

// Опеределить необходимость перерасчета статуса оформления документов.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ЧекЕГАИСВозврат - Документ, по которому требуется рассчитать статус оформления.
//  ПредыдущийСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Предыдущий статус.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыИнформированияЕГАИС - Предыдущий статус.
// 
// Возвращаемое значение:
//  Булево - Необходимость перерасчета статуса оформления.
//
Функция РассчитатьСтатусОформления(ДокументСсылка, ПредыдущийСтатус, НовыйСтатус) Экспорт
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область Серии

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий(Метаданные.Документы.ЧекЕГАИСВозврат);
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерий(Метаданные.Документы.ЧекЕГАИСВозврат, Объект);
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ТекстЗапросаЗаполненияСтатусовУказанияСерий(Метаданные.Документы.ЧекЕГАИСВозврат, ПараметрыУказанияСерий);

КонецФункции

#КонецОбласти

#Область Статусы

// Возвращает статус по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияЕГАИС - Статус по-умолчанию.
//
Функция СтатусПоУмолчанию() Экспорт
	
	Возврат ЧекиЕГАИС.СтатусПоУмолчанию();
	
КонецФункции

// Возвращает статусы движений.
//
// Возвращаемое значение:
//  Массив - Статусы.
//
Функция СтатусыДвиженийАкцизныхМарокСвободныйОстаток() Экспорт
	
	Возврат ЧекиЕГАИС.СтатусыДвиженийАкцизныхМарокСвободныйОстаток();
	
КонецФункции

// Возвращает статусы движений.
//
// Возвращаемое значение:
//  Массив - Статусы.
//
Функция СтатусыДвиженийАкцизныхМарокКоличество() Экспорт
	
	Возврат ЧекиЕГАИС.СтатусыДвиженийАкцизныхМарокКоличество();
	
КонецФункции

// Возвращает статусы ошибок.
//
// Возвращаемое значение:
//  Массив - Статусы ошибок.
//
Функция СтатусыОшибок() Экспорт
	
	Статусы = Новый Массив;
	
	Статусы.Добавить(Перечисления.СтатусыИнформированияЕГАИС.ОшибкаПередачи);
	
	Возврат Статусы;
	
КонецФункции

// Возвращает конечные статусы.
//
// Возвращаемое значение:
//  Массив - Конечные статусы.
//
Функция КонечныеСтатусы() Экспорт
	
	Статусы = Новый Массив;
	
	Возврат Статусы;
	
КонецФункции

// Возвращает дальнейшее действие по умолчанию.
// 
// Возвращаемое значение:
//  Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС - Дальнейшее действие по-умолчанию.
//
Функция ДальнейшееДействиеПоУмолчанию() Экспорт
	
	Возврат ЧекиЕГАИС.ДальнейшееДействиеПоУмолчанию();
	
КонецФункции

// Возвращает запрос для получения статуса оформления.
//
// Параметры:
//  ДокументОснование - ДокументСсылка - Документ основание.
// 
// Возвращаемое значение:
//  Запрос - Запрос для получения статуса оформления.
//
Функция ЗапросСтатусаОформления(ДокументОснование) Экспорт
	
	Запрос = ИнтеграцияЕГАИСПереопределяемый.ЗапросСтатусаОформленияЧекЕГАИСВозврат(ДокументОснование);
	
	Запрос.УстановитьПараметр("КонечныеСтатусы", КонечныеСтатусы());
	Запрос.УстановитьПараметр("КонечныеСтатусыЧекЕГАИС",         КонечныеСтатусы());
	Запрос.УстановитьПараметр("КонечныеСтатусыАктСписанияЕГАИС", Документы.АктСписанияЕГАИС.КонечныеСтатусы());
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти

#Область ПанельОбменСЕГАИС

Функция ВсеТребующиеДействия(Все = Ложь) Экспорт
	
	МассивДействий = Новый Массив;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные);
	Если Все Или Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ВыполнитеОбмен);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

Функция ВсеТребующиеОжидания(Все = Ложь) Экспорт
	
	МассивДействий = Новый Массив;
	Если Все Или ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхЕГАИС") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОформите() Экспорт
	
	Возврат ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаЧекЕГАИСВозвратОформите();
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЧекЕГАИСВозврат КАК ЧекЕГАИСВозврат
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ЧекЕГАИСВозврат.Ссылка
	|ГДЕ
	|	ЧекЕГАИСВозврат.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ЧекЕГАИСВозврат.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеДействия)
	|	И (ЧекЕГАИСВозврат.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ЧекЕГАИСВозврат.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаПанельОбменСЕГАИСОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыДокументовЕГАИС.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.ЧекЕГАИСВозврат КАК ЧекЕГАИСВозврат
	|ПО
	|	СтатусыДокументовЕГАИС.Документ = ЧекЕГАИСВозврат.Ссылка
	|ГДЕ
	|	ЧекЕГАИСВозврат.Ссылка ЕСТЬ НЕ NULL
	|	И НЕ ЧекЕГАИСВозврат.ПометкаУдаления
	|	И СтатусыДокументовЕГАИС.ДальнейшееДействие1 В(&ВсеТребующиеОжидания)
	|	И (ЧекЕГАИСВозврат.ОрганизацияЕГАИС В(&ОрганизацияЕГАИС)
	|		ИЛИ &БезОтбораПоОрганизацииЕГАИС)
	|	И (ЧекЕГАИСВозврат.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область СообщенияЕГАИС

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ВидыДокументовЕГАИС - Операция ЕГАИС
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные Тогда
		
		Возврат ЧекЕГАИСВозвратXML(ДокументСсылка);
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СканированиеАлкогольнойПродукции

Функция ТаблицаАлкогольнойПродукцииКОпределениюСправок2(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЧекЕГАИСВозвратТовары.АлкогольнаяПродукция           КАК АлкогольнаяПродукция,
	|	ЧекЕГАИСВозвратТовары.Номенклатура                   КАК Номенклатура,
	|	ЧекЕГАИСВозвратТовары.Характеристика                 КАК Характеристика,
	|	ЧекЕГАИСВозвратТовары.Серия                          КАК Серия,
	|	ЗНАЧЕНИЕ(Справочник.Справки2ЕГАИС.ПустаяСсылка)      КАК Справка2,
	|	СУММА(ЧекЕГАИСВозвратТовары.Количество)              КАК Количество,
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ) КАК Маркируемая
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.Товары КАК ЧекЕГАИСВозвратТовары
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО ЧекЕГАИСВозвратТовары.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции = ВидыАлкогольнойПродукции.Ссылка
	|ГДЕ
	|	ЧекЕГАИСВозвратТовары.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ЧекЕГАИСВозвратТовары.Номенклатура,
	|	ЧекЕГАИСВозвратТовары.АлкогольнаяПродукция,
	|	ЧекЕГАИСВозвратТовары.Характеристика,
	|	ЧекЕГАИСВозвратТовары.Серия,
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ)";
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция НаличиеМаркируемойПродукции(Ссылка) Экспорт 
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ЕстьМаркируемая", Ложь);
	СтруктураВозврата.Вставить("ЕстьНеМаркируемая", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ВидыАлкогольнойПродукции.Маркируемый КАК Маркируемый
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.Товары КАК ЧекЕГАИСВозвратТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО ЧекЕГАИСВозвратТовары.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО КлассификаторАлкогольнойПродукцииЕГАИС.ВидПродукции = ВидыАлкогольнойПродукции.Ссылка
	|ГДЕ
	|	ЧекЕГАИСВозвратТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Маркируемый Тогда
			СтруктураВозврата.ЕстьМаркируемая = Истина;
		Иначе
			СтруктураВозврата.ЕстьНеМаркируемая = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Функция ШтрихкодыУпаковок(ДокументСсылка, ЗаполнитьСправки2ИзРегистра = Ложь) Экспорт
	
	ПараметрыФормированияТекстаЗапроса = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыФормированияТекстаЗапросаВложенныхШтрихкодов();
	ПараметрыФормированияТекстаЗапроса.ДокументСсылка                  = ДокументСсылка;
	ПараметрыФормированияТекстаЗапроса.ИспользоватьИдентификаторСтроки = Истина;
	ПараметрыФормированияТекстаЗапроса.ИмяПоляОрганизацияЕГАИС         = "ОрганизацияЕГАИС";
	ПараметрыФормированияТекстаЗапроса.ЗаполнитьСправки2ИзРегистра     = ЗаполнитьСправки2ИзРегистра;
	
	Возврат Справочники.ШтрихкодыУпаковокТоваров.ШтрихкодыУпаковокПоДокументу(ПараметрыФормированияТекстаЗапроса);
	
КонецФункции

Функция ОбработатьШтрихкодPDF417(Форма, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок) Экспорт
	
	Возврат ЧекиЕГАИС.ОбработатьШтрихкодPDF417(Форма, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок);
	
КонецФункции

Функция ОбработатьШтрихкодУпаковки(Форма, ДанныеШтрихкода, ВложенныеШтрихкоды, ПараметрыСканированияАкцизныхМарок) Экспорт
	
	Возврат ЧекиЕГАИС.ОбработатьШтрихкодУпаковки(Форма, ДанныеШтрихкода, ВложенныеШтрихкоды, ПараметрыСканированияАкцизныхМарок);
	
КонецФункции

Функция ОбработатьШтрихкодDataMatrix(Форма, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок) Экспорт
	
	Возврат ЧекиЕГАИС.ОбработатьШтрихкодDataMatrix(Форма, ДанныеШтрихкода, ПараметрыСканированияАкцизныхМарок);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияЕГАИС

Функция ЧекЕГАИСВозвратXML(ДокументСсылка)
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	ЕГАИСПрисоединенныеФайлы.Документ      КАК Ссылка,
		|	КОЛИЧЕСТВО(ЕГАИСПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомер
		|ПОМЕСТИТЬ Версии
		|ИЗ
		|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
		|ГДЕ
		|	ЕГАИСПрисоединенныеФайлы.Документ = &Ссылка
		|	И ЕГАИСПрисоединенныеФайлы.Операция = &Операция
		|	И ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовЕГАИС.Исходящий)
		|СГРУППИРОВАТЬ ПО
		|	ЕГАИСПрисоединенныеФайлы.Документ
		|;
		|
		|//#РезультатЗапроса#////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Шапка.Номер                           КАК Номер,
		|	Шапка.Дата                            КАК Дата,
		|	ЕСТЬNULL(Версии.ПоследнийНомер, 0)    КАК ПоследнийНомерВерсии,
		|	Шапка.ДокументОснование               КАК ДокументОснование,
		|	Шапка.ОрганизацияЕГАИС                КАК ОрганизацияЕГАИС,
		|	Шапка.ОрганизацияЕГАИС.Код            КАК ИдентификаторФСРАР,
		|	Шапка.ОрганизацияЕГАИС.ФорматОбмена   КАК ФорматОбмена,
		|	Шапка.ОрганизацияЕГАИС.ИНН            КАК ИНН,
		|	Шапка.ОрганизацияЕГАИС.КПП            КАК КПП,
		|	Шапка.ОрганизацияЕГАИС.ТорговыйОбъект КАК ТорговыйОбъект,
		|	Шапка.Ответственный                   КАК Ответственный,
		|	Шапка.НомерСмены                      КАК НомерСмены,
		|	Шапка.НомерЧекаККМ                    КАК НомерЧекаККМ,
		|	Шапка.СерийныйНомерККМ                КАК СерийныйНомерККМ
		|ИЗ
		|	Документ.ЧекЕГАИСВозврат КАК Шапка,
		|		ЛЕВОЕ СОЕДИНЕНИЕ Версии КАК Версии
		|		ПО Шапка.Ссылка = Версии.Ссылка
		|ГДЕ
		|	Шапка.Ссылка = &Ссылка
		|",
		"Шапка");
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	Товары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
		|	Товары.Номенклатура         КАК Номенклатура,
		|	Товары.Характеристика       КАК Характеристика,
		|	Товары.Серия                КАК Серия
		|ПОМЕСТИТЬ ВТТовары
		|ИЗ
		|	Документ.ЧекЕГАИСВозврат.Товары КАК Товары
		|ГДЕ
		|	Товары.Ссылка = &Ссылка
		|");
	
	ТекстыЗапроса.Добавить(
		ИнтеграцияЕГАИС.ТекстЗапросаВТКоэффициентыПересчетаВЕдиницыЕГАИС(
			"ВТТовары",
			"ВТКоэффициентыПересчетаВЕдиницыЕГАИС"));
	
	ТекстыЗапроса.Добавить(
		"ВЫБРАТЬ
		|	Товары.ИдентификаторСтроки              КАК ИдентификаторСтроки,
		|	Товары.НомерСтроки                      КАК НомерСтроки,
		|	Товары.Количество
		|	* ЕСТЬNULL(ЕдиницыЕГАИС.Коэффициент, 1) КАК Количество,
		|	-Товары.Цена                            КАК Цена,
		|	Товары.Штрихкод                         КАК Штрихкод,
		|	Товары.АлкогольнаяПродукция.Объем       КАК Объем
		|ИЗ
		|	Документ.ЧекЕГАИСВозврат.Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоэффициентыПересчетаВЕдиницыЕГАИС КАК ЕдиницыЕГАИС
		|		ПО ЕдиницыЕГАИС.АлкогольнаяПродукция = Товары.АлкогольнаяПродукция
		|		 И ЕдиницыЕГАИС.Номенклатура = Товары.Номенклатура
		|		 И ЕдиницыЕГАИС.Характеристика = Товары.Характеристика
		|		 И ЕдиницыЕГАИС.Серия = Товары.Серия
		|ГДЕ
		|	Товары.Ссылка = &Ссылка
		|",
		"Товары");
	
	ПараметрыФормированияТекстаЗапроса = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыФормированияТекстаЗапросаВложенныхШтрихкодов();
	ПараметрыФормированияТекстаЗапроса.ДокументСсылка                  = ДокументСсылка;
	ПараметрыФормированияТекстаЗапроса.ИспользоватьИдентификаторСтроки = Истина;
	ТекстыЗапроса.Добавить(
		Справочники.ШтрихкодыУпаковокТоваров.ТекстЗапросаВложенныхШтрихкодовПоДокументу(ПараметрыФормированияТекстаЗапроса),
		"ВложенныеШтрихкоды");
	
	МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка",   ДокументСсылка);
	Запрос.УстановитьПараметр("Операция", Перечисления.ВидыДокументовЕГАИС.ЧекККМ);
	РезультатыЗапроса = ГосударственныеИнформационныеСистемы.ВыполнитьПакетЗапросов(Запрос, ТекстыЗапроса);
	
	Возврат ЧекиЕГАИС.ЧекЕГАИСXML(ДокументСсылка, РезультатыЗапроса, МенеджерВременныхТаблиц);
	
КонецФункции

#КонецОбласти

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры);
	
	ИнтеграцияЕГАИС.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.ОрганизацияЕГАИС  КАК ОрганизацияЕГАИС,
	|	ДанныеШапки.Ссылка            КАК Ссылка,
	|	ДанныеШапки.Дата              КАК Период,
	|	СтатусыДокументовЕГАИС.Статус КАК СтатусОбработки
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат КАК ДанныеШапки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовЕГАИС КАК СтатусыДокументовЕГАИС
	|		ПО СтатусыДокументовЕГАИС.Документ = ДанныеШапки.Ссылка
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Ссылка",           Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("ОрганизацияЕГАИС", Реквизиты.ОрганизацияЕГАИС);
	Запрос.УстановитьПараметр("СтатусОбработки",  Реквизиты.СтатусОбработки);
	Запрос.УстановитьПараметр("Период",           Реквизиты.Период);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если Не ИнтеграцияЕГАИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса = ИнтеграцияЕГАИСПереопределяемый.ТекстЗапросаДвижениеСерийТоваров(Метаданные.Документы.ЧекЕГАИСВозврат.Имя);
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
	
	Если НЕ ИнтеграцияЕГАИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период                            КАК Период,
	|	ТаблицаАкцизныеМарки.Ссылка        КАК Ссылка,
	|	&ОрганизацияЕГАИС                  КАК ОрганизацияЕГАИС,
	|	ТаблицаАкцизныеМарки.Справка2      КАК Справка2,
	|	Справки2ЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаАкцизныеМарки.АкцизнаяМарка) КАК Количество,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТаблицаАкцизныеМарки.АкцизнаяМарка) КАК СвободныйОстаток
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.АкцизныеМарки КАК ТаблицаАкцизныеМарки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	|			ПО Справки2ЕГАИС.Ссылка = ТаблицаАкцизныеМарки.Справка2
	|ГДЕ
	|	ТаблицаАкцизныеМарки.Ссылка = &Ссылка
	|	И &СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыИнформированияЕГАИС.ПереданВУТМ)
	|	И ТаблицаАкцизныеМарки.Справка2 <> ЗНАЧЕНИЕ(Справочник.Справки2ЕГАИС.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаАкцизныеМарки.Ссылка,
	|	ТаблицаАкцизныеМарки.Справка2,
	|	Справки2ЕГАИС.АлкогольнаяПродукция
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизныеМарки.Ссылка
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.АкцизныеМарки КАК АкцизныеМарки
	|ГДЕ
	|	АкцизныеМарки.КодАкцизнойМарки <> """"
	|	И АкцизныеМарки.АкцизнаяМарка = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ЧекЕГАИСВозврат";
	МетаданныеДокумента = Метаданные.Документы.ЧекЕГАИСВозврат;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			ОбработкаЗавершена = Истина;
			Для каждого ТекСтрока Из ДокументОбъект.АкцизныеМарки Цикл
				Если ЗначениеЗаполнено(ТекСтрока.КодАкцизнойМарки) Тогда
					ТекСтрока.АкцизнаяМарка = Справочники.ШтрихкодыУпаковокТоваров.ПолучитьАкцизнуюМаркуПоКоду(ТекСтрока.КодАкцизнойМарки);
					Если НЕ ЗначениеЗаполнено(ТекСтрока.АкцизнаяМарка) Тогда
						ОбработкаЗавершена = Ложь;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Если ОбработкаЗавершена Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
				ЗафиксироватьТранзакцию();
			Иначе
				ОтменитьТранзакцию();
			КонецЕсли;
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеДокумента,
				Выборка.Ссылка,
				ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеКОбработкеДляГенерацииАкцизныхМарок(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АкцизныеМарки.Ссылка
	|ИЗ
	|	Документ.ЧекЕГАИСВозврат.АкцизныеМарки КАК АкцизныеМарки
	|ГДЕ
	|	АкцизныеМарки.КодАкцизнойМарки <> """"
	|	И АкцизныеМарки.АкцизнаяМарка = ЗНАЧЕНИЕ(Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка)
	|";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюГенерацияАкцизныхМарок(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ЧекЕГАИСВозврат";
	МетаданныеДокумента = Метаданные.Документы.ЧекЕГАИСВозврат;
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();
			
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Если ДокументОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось заблокировать документ: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									МетаданныеДокумента,
									Выборка.Ссылка,
									ТекстСообщения);
			Продолжить;
		КонецПопытки;
		
		ОбработкаСсылкиЗавершена = Истина;
		Для каждого ТекСтрока Из ДокументОбъект.АкцизныеМарки Цикл
			Если ЗначениеЗаполнено(ТекСтрока.КодАкцизнойМарки) И НЕ ЗначениеЗаполнено(ТекСтрока.АкцизнаяМарка) Тогда
				СтрокаТовар = ДокументОбъект.Товары.Найти(ТекСтрока.ИдентификаторСтроки, "ИдентификаторСтроки");
				Попытка
					Справочники.ШтрихкодыУпаковокТоваров.ПолучитьСгенерироватьАкцизнуюМарку(ТекСтрока.КодАкцизнойМарки,
						СтрокаТовар.Номенклатура,
						СтрокаТовар.Характеристика,
						Истина);
				Исключение
						
					ТекстСообщения = НСтр("ru = 'Не удалось сгенерировать акцизную марку: %Ключ% по причине: %Причина%'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ключ%", ТекСтрока.КодАкцизнойМарки);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
						МетаданныеДокумента, ТекстСообщения);
					ОбработкаСсылкиЗавершена = Ложь;
					ОтменитьТранзакцию();
					Продолжить;
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;
		Если ОбработкаСсылкиЗавершена Тогда
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ЗафиксироватьТранзакцию();
		Иначе
			ОтменитьТранзакцию();
		КонецЕсли;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяДокумента);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли
