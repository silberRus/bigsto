﻿
#Область ПрограммныйИнтерфейс

#Область ЭтикеткиИЦенники

// Возвращает данные для печати этикеток или ценников,
//	получает эти данные из модулей менеджеров объектов печати.
//
// Параметры:
//	Идентификатор	- Строка - может принимать значения "Ценники" или "Этикетки";
//	ОбъектыПечати	- Массив - массив ссылок на объекты для печати, ссылки должны быть одного типа;
//	ДополнительныеПараметры	- Структура - параметры печати.
//
// Возвращаемое значение:
//	Строка	-	адрес структуры во временном хранилище, содержащей данные для печати.
//
Функция ДанныеДляПечатиЦенниковИЭтикеток(Идентификатор, ОбъектыПечати, ДополнительныеПараметры) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектыПечати[0]);
	
	СоответствиеОбъектов = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(ОбъектыПечати);
	Если СоответствиеОбъектов.Количество() > 1 Тогда
		ТекстСообщения = НСтр("ru = 'Печать этикеток и ценников для нескольких видов документов не поддерживается'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Идентификатор = "Ценники" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЦенников(ОбъектыПечати);	
	ИначеЕсли Идентификатор = "Этикетки" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЭтикеток(ОбъектыПечати);
	КонецЕсли;
	
КонецФункции

// Возвращает данные для печати этикеток складских ячеек
//
// Параметры:
//  Идентификатор	 - Строка - Идентификатор команды печати,
//  ОбъектыПечати	- Массив - массив ссылок СправочникСсылка.СкладскиеЯчейки
// 
// Возвращаемое значение:
//   - Строка	-	адрес структуры во временном хранилище, содержащей данные для печати
//
Функция ДанныеДляПечатиЭтикетокСкладскиеЯчейки(Идентификатор, ОбъектыПечати) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Владелец КАК Склад,
	|	СкладскиеЯчейки.Помещение
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В(&Ячейки)";
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() <> 1 Тогда
		ТекстИсключения = НСтр("ru = 'Выделены ячейки разных складских территорий (помещений).
			|Одновременно можно печатать этикетки только по ячейкам, принадлежащим одной складской территории (помещению).'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Выборка.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Ссылка КАК Ячейка
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В ИЕРАРХИИ(&Ячейки)
	|	И НЕ СкладскиеЯчейки.ПометкаУдаления
	|	И НЕ СкладскиеЯчейки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	СкладскиеЯчейки.Код";
	
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	ТаблицаЯчеек = Запрос.Выполнить().Выгрузить();
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склад", 	  Выборка.Склад);
	СтруктураПараметров.Вставить("Помещение", Выборка.Помещение);
	СтруктураПараметров.Вставить("Ячейки",    ТаблицаЯчеек);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураПараметров);
	
КонецФункции

#КонецОбласти

#Область Инв3_Инв19

// Возвращает структуру параметров формирования ПФ ИНВ3 и ИНВ19. 
//
// Параметры:
//  МассивПересчетов - 	Массив - массив ссылок на документы "Пересчет товаров"
// 
// Возвращаемое значение:
//  Стуктура - структура параметров с ключами
//		*Описи - Массив - массив инвентаризационных описей, в инвентаризациооный период которых попадают пересчеты из МассивПересчетов
//		*Склады - Массив - массив складов из пересчетов МассивПересчетов
//		*ДатаНачала - Дата - минимальная дата начала инвентаризационного периода из всех полученных описей, 
//							если описи не найдены, то минимальная дата из всех пересчетов
//		*ДатаОкончания - Дата - максимальная дата окончания инвентаризационного периода из всех полученных описей, 
//							если описи не найдены, то максимальная дата из всех пересчетов
//		*Организации - Массив - массив организация из списка описей
//
Функция ПолучитьПараметрыФормирования(МассивПересчетов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивПересчетов", МассивПересчетов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПересчетТоваров.Ссылка КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(ПересчетТоваров.Дата, ДЕНЬ) КАК Дата,
	|	ПересчетТоваров.Склад
	|ПОМЕСТИТЬ СписокПересчетов
	|ИЗ
	|	Документ.ПересчетТоваров КАК ПересчетТоваров
	|ГДЕ
	|	ПересчетТоваров.Ссылка В(&МассивПересчетов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИнвентаризационнаяОпись.Ссылка,
	|	ИнвентаризационнаяОпись.Организация,
	|	ИнвентаризационнаяОпись.ДатаНачала,
	|	ИнвентаризационнаяОпись.ДатаОкончания,
	|	ИнвентаризационнаяОпись.Склад
	|ПОМЕСТИТЬ СписокОписей
	|ИЗ
	|	Документ.ИнвентаризационнаяОпись КАК ИнвентаризационнаяОпись
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокПересчетов КАК ПересчетТоваров
	|		ПО (ПересчетТоваров.Склад = ИнвентаризационнаяОпись.Склад)
	|			И (ПересчетТоваров.Дата МЕЖДУ ИнвентаризационнаяОпись.ДатаНачала И ИнвентаризационнаяОпись.ДатаОкончания)
	|ГДЕ
	|	ИнвентаризационнаяОпись.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокОписей.Ссылка КАК Ссылка
	|ИЗ
	|	СписокОписей КАК СписокОписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписокПересчетов.Склад
	|ИЗ
	|	СписокПересчетов КАК СписокПересчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(СписокОписей.ДатаНачала) КАК ДатаНачала,
	|	МАКСИМУМ(СписокОписей.ДатаОкончания) КАК ДатаОкончания
	|ИЗ
	|	СписокОписей КАК СписокОписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(СписокПересчетов.Дата) КАК ДатаНачала,
	|	МАКСИМУМ(СписокПересчетов.Дата) КАК ДатаОкончания
	|ИЗ
	|	СписокПересчетов КАК СписокПересчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписокОписей.Организация
	|ИЗ
	|	СписокОписей КАК СписокОписей";
	Результат = Запрос.ВыполнитьПакет();
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("Описи", Результат[2].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	ПараметрыФормирования.Вставить("Склады", Результат[3].Выгрузить().ВыгрузитьКолонку("Склад"));
	Выборка = Результат[4].Выбрать();
	Выборка.Следующий();
	ПараметрыФормирования.Вставить("ДатаНачала", Выборка.ДатаНачала);
	ПараметрыФормирования.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
	Если НЕ ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала) Тогда
		Выборка = Результат[5].Выбрать();
		Выборка.Следующий();
		ПараметрыФормирования.Вставить("ДатаНачала", Выборка.ДатаНачала);
		ПараметрыФормирования.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
	КонецЕсли;
	ПараметрыФормирования.Вставить("Организации", Результат[6].Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Возврат ПараметрыФормирования;
	
КонецФункции

#КонецОбласти

#Область Км3

// Проверяет проведенность и статус "Пробит" документов для печати ИНВ3
//
// Параметры:
//  Идентификатор	- Строка - Идентификатор команды печати,
//  ОбъектыПечати	- Массив - массив ссылок на объекты для печати
// 
// Возвращаемое значение:
//  Структура - структура параметров с ключами
//		*КоличествоЧеков	- Число - Количество проведенных и пробитых чеков,
//		*КоличествоОтчетов	- Число - Количество проведенных отчетов
//
Функция ПроверитьПроведенностьИСтатусПробитДокументовДляПечатиИНВ3(Идентификатор, ОбъектыПечати) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВложенныйЗапрос.КоличествоЧеков) КАК КоличествоЧеков,
	|	СУММА(ВложенныйЗапрос.КоличествоОтчетов) КАК КоличествоОтчетов
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОЛИЧЕСТВО(Документ.Ссылка) КАК КоличествоЧеков,
	|		0 КАК КоличествоОтчетов
	|	ИЗ
	|		Документ.ЧекККМВозврат КАК Документ
	|	ГДЕ
	|		Документ.Ссылка В(&МассивДокументов)
	|		И НЕ Документ.Проведен
	|		И НЕ Документ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КОЛИЧЕСТВО(Документ.Ссылка) КАК КоличествоЧеков,
	|		0 КАК КоличествоОтчетов
	|	ИЗ
	|		Документ.ВозвратПодарочныхСертификатов КАК Документ
	|	ГДЕ
	|		Документ.Ссылка В(&МассивДокументов)
	|		И НЕ Документ.Проведен
	|		И НЕ Документ.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЧековККМ.Пробит)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		0,
	|		КОЛИЧЕСТВО(Документ.Ссылка)
	|	ИЗ
	|		Документ.ОтчетОРозничныхПродажах КАК Документ
	|	ГДЕ
	|		Документ.Ссылка В(&МассивДокументов)
	|		И НЕ Документ.Проведен) КАК ВложенныйЗапрос";
		
	Запрос.УстановитьПараметр("МассивДокументов", ОбъектыПечати);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Выбрать();
	ВозвращаемоеЗначение = Новый Структура("КоличествоЧеков, КоличествоОтчетов", 0, 0);
	Если Выборка.Следующий() Тогда
		ВозвращаемоеЗначение.КоличествоЧеков   = Выборка.КоличествоЧеков;
		ВозвращаемоеЗначение.КоличествоОтчетов = Выборка.КоличествоОтчетов;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;

КонецФункции

#КонецОбласти

#Область ТТН

// Возвращает данные связанных с объектами печати транспортных накладных
//
// Параметры:
//  ОбъектыПечати	- Массив - массив ссылок на объекты для печати
// 
// Возвращаемое значение:
//  Структура - структура параметров с ключами
//		*МассивДокументовБезНакладных	- Массив - Ссылки на объекты печати без транспортных накладных,
//		*ТранспортныеНакладныеНаПечать	- ТаблицаЗначений - Данные транспортных накладных для печати
//
Функция ПолучитьТранспортныеНакладныеНаПечать(ОбъектыПечати) Экспорт
	
	ТипДокументов = ТипЗнч(ОбъектыПечати[0]);
	МассивДокументовБезНакладных = Новый Массив;
	
	Запрос = Новый Запрос;
				
	Если ТипДокументов = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		
		Запрос.УстановитьПараметр("ЗаданияНаПеревозку",        ОбъектыПечати);
		Запрос.УстановитьПараметр("НетВыделенныхСтрокАдресов", Истина);
		Запрос.УстановитьПараметр("ВыделенныеСтрокиАдресов",   Новый Массив);
		Запрос.УстановитьПараметр("ВсеРаспоряжения",           Истина);
		Запрос.УстановитьПараметр("Распоряжения",              Новый Массив);
		
		Запрос.Текст = Документы.ЗаданиеНаПеревозку.ТекстЗапросаПолученияСпискаНакладныхИзЗаданийНаПеревозку() + 
		"ВЫБРАТЬ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка КАК ТранспортнаяНакладная,
		|	НакладныеПоЗаданиямНаПеревозку.ЗаданиеНаПеревозку КАК ДокументОснование,
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Дата КАК Дата,
		|	НакладныеПоЗаданиямНаПеревозку.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ТранспортныеНакладныеИОснования
		|ИЗ
		|	НакладныеПоЗаданиямНаПеревозку КАК НакладныеПоЗаданиямНаПеревозку
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
		|		ПО НакладныеПоЗаданиямНаПеревозку.Накладная = ТранспортнаяНакладнаяДокументыОснования.ДокументОснование
		|			И НакладныеПоЗаданиямНаПеревозку.ЗаданиеНаПеревозку = ТранспортнаяНакладнаяДокументыОснования.Ссылка.ЗаданиеНаПеревозку
		|ГДЕ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладныеИОснования.НомерСтроки КАК НомерСтроки,
		|	ТранспортныеНакладныеИОснования.ДокументОснование КАК ДокументОснование,
		|	ТранспортныеНакладныеИОснования.Дата
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранспортныеНакладныеИОснования.ДокументОснование,
		|	ТранспортныеНакладныеИОснования.НомерСтроки,
		|	ТранспортныеНакладныеИОснования.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ДокументОснование
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования";
		
		НомерТаблицыДокументыОснования = 4;
		НомерТаблицыТранспортныеНакладныеНаПечать = 3;
		
	Иначе
		
		Запрос.УстановитьПараметр("ОбъектыПечати", ОбъектыПечати);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка КАК ТранспортнаяНакладная,
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Дата КАК Дата,
		|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование
		|ПОМЕСТИТЬ ТранспортныеНакладныеИОснования
		|ИЗ
		|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
		|ГДЕ
		|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование В(&ОбъектыПечати)
		|	И НЕ ТранспортнаяНакладнаяДокументыОснования.Ссылка.ПометкаУдаления
		|	И ТранспортнаяНакладнаяДокументыОснования.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладныеИОснования.Дата
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранспортныеНакладныеИОснования.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ДокументОснование
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования";
		
		НомерТаблицыДокументыОснования = 2;
		НомерТаблицыТранспортныеНакладныеНаПечать = 1;
				
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	ДокументыОснования = РезультатЗапроса[НомерТаблицыДокументыОснования].Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	ТаблицаТранспортныеНакладныеНаПечать = РезультатЗапроса[НомерТаблицыТранспортныеНакладныеНаПечать].Выгрузить();
	ТаблицаТранспортныеНакладныеНаПечать.Свернуть("ТранспортнаяНакладная");
	ТранспортныеНакладныеНаПечать = ТаблицаТранспортныеНакладныеНаПечать.ВыгрузитьКолонку("ТранспортнаяНакладная");
	
	Для	Каждого ОбъектПечати Из ОбъектыПечати Цикл
		
		Если ДокументыОснования.Найти(ОбъектПечати) = Неопределено Тогда
			МассивДокументовБезНакладных.Добавить(ОбъектПечати);	
		КонецЕсли;
		
	КонецЦикла;	 
	
	Структура = Новый Структура;
	Структура.Вставить("МассивДокументовБезНакладных", МассивДокументовБезНакладных);
	Структура.Вставить("ТранспортныеНакладныеНаПечать", ТранспортныеНакладныеНаПечать);
	
	Возврат Структура;	
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЭтикеткиИЦенники

// См. Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокДоставки
//
Функция ДанныеДляПечатиЭтикетокДоставки(Идентификатор, ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокДоставки(ОбъектыПечати);
	
КонецФункции

// См. Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокУпаковочныеЛисты
//
Функция ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати);
	
КонецФункции

// Возвращает данные для печати акцизных марок.
//
// Параметры:
//  Идентификатор	 - Строка - Идентификатор команды печати,
//  ОбъектыПечати	- Массив - массив ссылок ДокументСсылка.ЗапросАкцизныхМарокЕГАИС.
// 
// Возвращаемое значение:
//   - Строка	-	адрес структуры во временном хранилище, содержащей данные для печати
//
Функция ДанныеДляПечатиАкцизныхМарок(Идентификатор, ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиАкцизныхМарок(ОбъектыПечати);
	
КонецФункции

// Возвращает данные для печати штрихкодов упаковок.
//
// Параметры:
//	 Идентификатор   - Строка - Идентификатор команды печати.
//	 ОбъектыПечати   - Массив - Массив ссылок СправочникСсылка.ШтрихкодыУпаковокТоваров.
//	                          - Массив структур-свойств штрихкодов, не записанных в базу данных, свойства структур:
//	                             *ТипУпаковки  - ПеречислениеСсылка.ТипыУпаковок - обязательное заполнение.
//	                             *ТипШтрихкода - ПеречислениеСсылка.ТипыШтрихкодов - обязательное заполнение.
//	                             *ЗначениеШтрихкода - Строка - сгенерированный штрихкод (в формате с заключенными
//	                              в скобки ключами идентификаторов применения) - обязательное заполнение.
//	                             *Номенклатура - СправочникСсылка.Номенклатура.
//	                             *Характеристика - СправочникСсылка.ХарактеристикаНоменклатуры.
//	
// Возвращаемое значение:
//	  - Строка	-	адрес структуры во временном хранилище, содержащей данные для печати
//
Функция ДанныеДляПечатиШтрихкодовУпаковок(Идентификатор, ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиШтрихкодовУпаковок(ОбъектыПечати);
	
КонецФункции

#КонецОбласти

#Область ТТН

// См. Документы.ТранспортнаяНакладная.ПроверитьНаличиеТранспортныхНакладныхДляРаспоряженийИзЗаданийНаПеревозку
//
Функция ПроверитьНаличиеТранспортныхНакладныхДляРаспоряженийИзЗаданийНаПеревозку(МассивОбъектов) Экспорт
	Возврат	Документы.ТранспортнаяНакладная.ПроверитьНаличиеТранспортныхНакладныхДляРаспоряженийИзЗаданийНаПеревозку(МассивОбъектов);
КонецФункции

// См. Документы.ТранспортнаяНакладная.ПроверитьНаличиеТранспортныхНакладныхДляРаспоряжений
//
Функция ПроверитьНаличиеТранспортныхНакладныхДляРаспоряжений(МассивОбъектов) Экспорт
	Возврат	Документы.ТранспортнаяНакладная.ПроверитьНаличиеТранспортныхНакладныхДляРаспоряжений(МассивОбъектов);
КонецФункции

// См. Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладныеДляЗаданийНаПеревозку
//
Функция СоздатьТранспортныеНакладныеДляЗаданийНаПеревозку(МассивОбъектов) Экспорт
	ТранспортныеНакладные = Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладныеДляЗаданийНаПеревозку(МассивОбъектов);
	Возврат ТранспортныеНакладные;
КонецФункции

// См. Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладные
//
Функция СоздатьТранспортныеНакладные(МассивОбъектов) Экспорт
	ТранспортныеНакладные = Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладные(МассивОбъектов);
	Возврат ТранспортныеНакладные;
КонецФункции

#КонецОбласти

#КонецОбласти