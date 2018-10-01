﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция определяет группу финансового учета по умолчанию.
//
// Возвращает группу финансового учета, если найден один элемент справочника.
// Возвращает ПустуюСсылку в противном случае
//
// Параметры:
//	ПорядокОплаты - ПеречислениеСсылка.ПорядокОплатыПоСоглашениям - порядок оплаты, для которого определяется группа финансового учета.
//
// Возвращаемое значение:
//	ГруппаФинансовогоУчета - СправочникСсылка.ГруппыФинансовогоУчетаРасчетов - группа фин. учета по умолчанию.
//
Функция ПолучитьГруппуФинансовогоУчетаПоУмолчанию(ПорядокОплаты, ХозяйственнаяОперация = Неопределено, ГФУПолучателя = Ложь) Экспорт
	
	СтруктураОтбора = Новый Структура("ПорядокОплаты", ПорядокОплаты);
	Если ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		СтруктураОтбора.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	КонецЕсли;
	Если ГФУПолучателя Тогда
		СтруктураОтбора.Вставить("ГФУПолучателя", Истина);
	КонецЕсли;
	
	ПреобразоватьОтборПараметровВыбора(СтруктураОтбора);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ДанныеСправочника.Ссылка КАК ГруппаФинансовогоУчета
	|ИЗ
	|	Справочник.ГруппыФинансовогоУчетаРасчетов КАК ДанныеСправочника
	|ГДЕ
	|	НЕ ДанныеСправочника.ПометкаУдаления
	|	И Не ДанныеСправочника.ЭтоГруппа
	|	И &ДопУсловияОтбора
	|");
	
	ДопУсловияОтбора = "ИСТИНА";
	ШаблонЭлементаОтбора = "И ДанныеСправочника.%1 = &%1";
	Для каждого ЭлементОтбора из СтруктураОтбора Цикл
		ДопУсловияОтбора = ДопУсловияОтбора + Символы.ПС + Символы.Таб + СтрШаблон(ШаблонЭлементаОтбора, ЭлементОтбора.Ключ);
		Запрос.УстановитьПараметр(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
	КонецЦикла;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ДопУсловияОтбора", ДопУсловияОтбора);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		ГруппаФинансовогоУчета = Выборка.ГруппаФинансовогоУчета;
	Иначе
		ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаРасчетов.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ГруппаФинансовогоУчета;

КонецФункции

// Функция определяет реквизиты выбранной группы финансового учета.
//
// Параметры:
//  ГруппаФинансовогоУчета - СправочникСсылка.ГруппыФинансовогоУчетаРасчетов - Ссылка на группу финансового учета
//
// Возвращаемое значение:
//	Структура - реквизиты группы финансового учета
//
Функция ПолучитьРеквизитыГруппыФинансовогоУчета(ГруппаФинансовогоУчета) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеСправочника.ПорядокОплаты КАК ПорядокОплаты
	|ИЗ
	|	Справочник.ГруппыФинансовогоУчетаРасчетов КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.Ссылка = &ГруппаФинансовогоУчета
	|");
	
	Запрос.УстановитьПараметр("ГруппаФинансовогоУчета", ГруппаФинансовогоУчета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПорядокОплаты = Выборка.ПорядокОплаты;
	Иначе
		ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПустаяСсылка();
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("ПорядокОплаты", ПорядокОплаты);
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Процедура преобразует отбор переданный в параметрах выбора в корректный отбор в рамках текущей ГФУ^
//		Если ПорядокОплаты не заполнен - отбор по данному порядку оплаты очищается;
//		Если передано соглашение или договор, то порядок оплаты берется из данных соответствующего значения;
//		Если передана хозяйственная операция, то по соответствию подбирается правильный тип расчетов для отбора.
//
//	Входные параметры:
//		Отбор - структура (см. Параметры.Отбор в обработке получения данных выбора).
//
Процедура ПреобразоватьОтборПараметровВыбора(Отбор) Экспорт
	
	#Область ПорядокОплаты
	Если Отбор.Свойство("ПорядокОплаты") И Не ЗначениеЗаполнено(Отбор.ПорядокОплаты) Тогда
		Отбор.Удалить("ПорядокОплаты");
	КонецЕсли;
	
	ПорядокОплаты = Неопределено;
	Если Отбор.Свойство("Договор") И ЗначениеЗаполнено(Отбор.Договор) Тогда
		ПорядокОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.Договор, "ПорядокОплаты");		
	ИначеЕсли Отбор.Свойство("Соглашение") И ЗначениеЗаполнено(Отбор.Соглашение) Тогда
		ПорядокОплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.Соглашение, "ПорядокОплаты");		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПорядокОплаты) Тогда
		Отбор.Вставить("ПорядокОплаты", ПорядокОплаты);
	КонецЕсли;
	#КонецОбласти
	
	#Область Расчеты
	
	Если Отбор.Свойство("ХозяйственнаяОперация") И ЗначениеЗаполнено(Отбор.ХозяйственнаяОперация) Тогда
		
		Операции = Перечисления.ХозяйственныеОперации;
		СоответстиеХОиРасчетов = Новый Соответствие;
		
		// Для интеркомпани вид расчетов выбирается еще и в зависимости от того, это ГФУ получателя или поставщика.
		ГФУПолучателя = Отбор.Свойство("ГФУПолучателя") И Отбор.ГФУПолучателя;
		
		СоответстиеХОиРасчетов.Вставить(Операции.РеализацияКлиенту, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ЗакупкаУПоставщика, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ПередачаНаКомиссию, "РасчетыСКомиссионерами");
		СоответстиеХОиРасчетов.Вставить(Операции.ПриемНаКомиссию, "РасчетыСКомитентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ЗакупкаПоИмпорту, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ПроизводствоИзДавальческогоСырья, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ПроизводствоУПереработчика, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ЗакупкаВСтранахЕАЭС, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ПриемНаХранениеСПравомПродажи, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ОказаниеАгентскихУслуг, "РасчетыСКомитентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратТоваровМеждуОрганизациями, ?(ГФУПолучателя, "РасчетыСПоставщиками", "РасчетыСКлиентами"));
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратТоваровОтКлиента, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратОтРозничногоПокупателя, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратТоваровПоставщику, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.РеализацияБезПереходаПраваСобственности, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.РеализацияТоваровВДругуюОрганизацию, ?(ГФУПолучателя, "РасчетыСПоставщиками", "РасчетыСКлиентами"));
		СоответстиеХОиРасчетов.Вставить(Операции.ПередачаНаКомиссиюВДругуюОрганизацию, ?(ГФУПолучателя, "РасчетыСКомитентами", "РасчетыСКомиссионерами"));
		СоответстиеХОиРасчетов.Вставить(Операции.ПоступлениеОплатыОтКлиента, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ПоступлениеДенежныхСредствИзДругойОрганизации, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратДенежныхСредствОтПоставщика, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратДенежныхСредствОтДругойОрганизации, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ОплатаПоставщику, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ОплатаДенежныхСредствВДругуюОрганизацию, "РасчетыСПоставщиками");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратОплатыКлиенту, "РасчетыСКлиентами");
		СоответстиеХОиРасчетов.Вставить(Операции.ВозвратДенежныхСредствВДругуюОрганизацию, "РасчетыСКлиентами");
		// Для договоров кредитов/депозитов и между организациями вместо ХО передаем характер или тип договора соответственно:
		СоответстиеХОиРасчетов.Вставить(Перечисления.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм, "РасчетыСКредиторами");
		СоответстиеХОиРасчетов.Вставить(Перечисления.ХарактерДоговораКредитовИДепозитов.ЗаймВыданный, "РасчетыСДебиторами");
		СоответстиеХОиРасчетов.Вставить(Перечисления.ХарактерДоговораКредитовИДепозитов.Депозит, "РасчетыСДебиторами");
		СоответстиеХОиРасчетов.Вставить(Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа, ?(ГФУПолучателя, "РасчетыСПоставщиками", "РасчетыСКлиентами"));
		СоответстиеХОиРасчетов.Вставить(Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный, ?(ГФУПолучателя, "РасчетыСКомитентами", "РасчетыСКомиссионерами"));
	
		ЗначениеРасчетов = СоответстиеХОиРасчетов.Получить(Отбор.ХозяйственнаяОперация);
		Если ЗначениеРасчетов <> Неопределено Тогда
			Отбор.Вставить(ЗначениеРасчетов, Истина);
		КонецЕсли;
		
		Отбор.Удалить("ХозяйственнаяОперация");
		
	КонецЕсли;
	
	Если Отбор.Свойство("ГФУПолучателя") Тогда
		Отбор.Удалить("ГФУПолучателя");
	КонецЕсли;
	
	#КонецОбласти
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	ОбщегоНазначенияУТВызовСервера.ОбработкаПолученияДанныхВыбораГруппыФинансовогоУчетаРасчетов(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УП 2.4.1,
// заполняет реквизит "Группа финансового учета получателя" документа "ОтчетПоКомиссииМеждуОрганизациями".
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ГруппыФинансовогоУчетаРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыФинансовогоУчетаРасчетов КАК ГруппыФинансовогоУчетаРасчетов
	|ГДЕ
	|	ГруппыФинансовогоУчетаРасчетов.ПометкаУдаления = ЛОЖЬ
	|	И ГруппыФинансовогоУчетаРасчетов.РасчетыСКлиентами = ЛОЖЬ
	|	И ГруппыФинансовогоУчетаРасчетов.РасчетыСПоставщиками = ЛОЖЬ
	|	И ГруппыФинансовогоУчетаРасчетов.РасчетыСКомиссионерами = ЛОЖЬ
	|	И ГруппыФинансовогоУчетаРасчетов.РасчетыСКомитентами = ЛОЖЬ
	|	И ГруппыФинансовогоУчетаРасчетов.РасчетыСКредиторами = ЛОЖЬ
	|	И ГруппыФинансовогоУчетаРасчетов.РасчетыСДебиторами = ЛОЖЬ
	|");
	
	ГруппыФинансовогоУчетаРасчетов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ГруппыФинансовогоУчетаРасчетов);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.ГруппыФинансовогоУчетаРасчетов";
	
	МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорыКонтрагентов.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем)
	|		ИЛИ ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СДавальцем) КАК РасчетыСКлиентами,
	|	ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПоставщиком)
	|		ИЛИ ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.Импорт)
	|		ИЛИ ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПереработчиком) КАК РасчетыСПоставщиками,
	|	ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СКомиссионером) КАК РасчетыСКомиссионерами,
	|	ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СКомитентом) КАК РасчетыСКомитентами,
	|	ЛОЖЬ КАК РасчетыСКредиторами,
	|	ЛОЖЬ КАК РасчетыСДебиторами,
	|	ЛОЖЬ КАК Кредит,
	|	ЛОЖЬ КАК Займ,
	|	ЛОЖЬ КАК Краткосрочный,
	|	ЛОЖЬ КАК Долгосрочный,
	|	ЛОЖЬ КАК РегламентированнаяВалюта,
	|	ЛОЖЬ КАК ВалютныйДоговор,
	|	ЛОЖЬ КАК Депозит,
	|	ЛОЖЬ КАК ЗаймВыданный
	|ПОМЕСТИТЬ ГФУ
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ДоговорыКонтрагентов.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ДоговорыКонтрагентов.ПометкаУдаления
	|	И ДоговорыКонтрагентов.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорыКредитовИДепозитов.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ДоговорыКредитовИДепозитов.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм),
	|	ДоговорыКредитовИДепозитов.ХарактерДоговора <> ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм),
	|	ДоговорыКредитовИДепозитов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговораКредитовИДепозитов.КредитВБанке) И ДоговорыКредитовИДепозитов.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм),
	|	ДоговорыКредитовИДепозитов.ТипДоговора <> ЗНАЧЕНИЕ(Перечисление.ТипыДоговораКредитовИДепозитов.КредитВБанке) И ДоговорыКредитовИДепозитов.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.КредитИлиЗайм),
	|	ДоговорыКредитовИДепозитов.ТипСрочности = ЗНАЧЕНИЕ(Перечисление.ТипыСрочностиКредитовИДепозитов.Краткосрочный),
	|	ДоговорыКредитовИДепозитов.ТипСрочности = ЗНАЧЕНИЕ(Перечисление.ТипыСрочностиКредитовИДепозитов.Долгосрочный),
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов <> Константы.ВалютаРегламентированногоУчета,
	|	ДоговорыКредитовИДепозитов.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.Депозит),
	|	ДоговорыКредитовИДепозитов.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерДоговораКредитовИДепозитов.ЗаймВыданный)
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ДоговорыКредитовИДепозитов.ГруппаФинансовогоУчета)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО ИСТИНА
	|
	|ГДЕ
	|	НЕ ДоговорыКредитовИДепозитов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДоговорыМеждуОрганизациями.ГруппаФинансовогоУчета,
	|	ДоговорыМеждуОрганизациями.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровМеждуОрганизациями.КупляПродажа),
	|	ДоговорыМеждуОрганизациями.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровМеждуОрганизациями.КупляПродажа),
	|	ДоговорыМеждуОрганизациями.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровМеждуОрганизациями.Комиссионный),
	|	ДоговорыМеждуОрганизациями.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровМеждуОрганизациями.Комиссионный),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.ДоговорыМеждуОрганизациями КАК ДоговорыМеждуОрганизациями
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ДоговорыМеждуОрганизациями.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ДоговорыМеждуОрганизациями.ПометкаУдаления
	|	И ДоговорыМеждуОрганизациями.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияСКлиентами.ГруппаФинансовогоУчета,
	|	СоглашенияСКлиентами.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту),
	|	ЛОЖЬ,
	|	СоглашенияСКлиентами.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.СоглашенияСКлиентами КАК СоглашенияСКлиентами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = СоглашенияСКлиентами.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ СоглашенияСКлиентами.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияСПоставщиками.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	СоглашенияСПоставщиками.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
	|		ИЛИ СоглашенияСПоставщиками.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту)
	|		ИЛИ СоглашенияСПоставщиками.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС),
	|	ЛОЖЬ,
	|	СоглашенияСПоставщиками.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОказаниеАгентскихУслуг)
	|		ИЛИ СоглашенияСПоставщиками.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПриемНаКомиссию),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.СоглашенияСПоставщиками КАК СоглашенияСПоставщиками
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = СоглашенияСПоставщиками.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ СоглашенияСПоставщиками.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	АктВыполненныхРабот.ГруппаФинансовогоУчета,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.АктВыполненныхРабот КАК АктВыполненныхРабот
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = АктВыполненныхРабот.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ АктВыполненныхРабот.ПометкаУдаления
	|	И АктВыполненныхРабот.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВозвратТоваровМеждуОрганизациями.ГруппаФинансовогоУчета,
	|	ВозвратТоваровМеждуОрганизациями.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями),
	|	ВозвратТоваровМеждуОрганизациями.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ВозвратТоваровМеждуОрганизациями КАК ВозвратТоваровМеждуОрганизациями
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ВозвратТоваровМеждуОрганизациями.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ВозвратТоваровМеждуОрганизациями.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВозвратТоваровОтКлиента.ГруппаФинансовогоУчета,
	|	ВозвратТоваровОтКлиента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиента)
	|		ИЛИ ВозвратТоваровОтКлиента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ВозвратТоваровОтКлиента КАК ВозвратТоваровОтКлиента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ВозвратТоваровОтКлиента.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ВозвратТоваровОтКлиента.ПометкаУдаления
	|	И ВозвратТоваровОтКлиента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВозвратТоваровПоставщику.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ВозвратТоваровПоставщику.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратТоваровПоставщику),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ВозвратТоваровПоставщику КАК ВозвратТоваровПоставщику
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ВозвратТоваровПоставщику.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ВозвратТоваровПоставщику.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыкупВозвратнойТарыКлиентом.ГруппаФинансовогоУчета,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыКлиентом КАК ВыкупВозвратнойТарыКлиентом
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ВыкупВозвратнойТарыКлиентом.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ВыкупВозвратнойТарыКлиентом.ПометкаУдаления
	|	И ВыкупВозвратнойТарыКлиентом.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыкупВозвратнойТарыУПоставщика.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ВыкупВозвратнойТарыУПоставщика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ВыкупВозвратнойТарыУПоставщика.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ВыкупВозвратнойТарыУПоставщика.ПометкаУдаления
	|	И ВыкупВозвратнойТарыУПоставщика.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказКлиента.ГруппаФинансовогоУчета,
	|	ЗаказКлиента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту)
	|		ИЛИ ЗаказКлиента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ЗаказКлиента.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ЗаказКлиента.ПометкаУдаления
	|	И ЗаказКлиента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоЗаказамНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказПоставщику.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЗаказПоставщику.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
	|		ИЛИ ЗаказПоставщику.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту)
	|		ИЛИ ЗаказПоставщику.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ЗаказПоставщику.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ЗаказПоставщику.ПометкаУдаления
	|	И ЗаказПоставщику.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоЗаказамНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаявкаНаВозвратТоваровОтКлиента.ГруппаФинансовогоУчета,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаявкаНаВозвратТоваровОтКлиента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ЗаявкаНаВозвратТоваровОтКлиента.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ЗаявкаНаВозвратТоваровОтКлиента.ПометкаУдаления
	|	И ЗаявкаНаВозвратТоваровОтКлиента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоЗаказамНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетКомиссионера.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ОтчетКомиссионера
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ОтчетКомиссионера.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ОтчетКомиссионера.ПометкаУдаления
	|	И ОтчетКомиссионера.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетКомиссионераОСписании.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ОтчетКомиссионераОСписании КАК ОтчетКомиссионераОСписании
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ОтчетКомиссионераОСписании.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ОтчетКомиссионераОСписании.ПометкаУдаления
	|	И ОтчетКомиссионераОСписании.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетКомитенту.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ОтчетКомитенту КАК ОтчетКомитенту
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ОтчетКомитенту.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ОтчетКомитенту.ПометкаУдаления
	|	И ОтчетКомитенту.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетКомитентуОСписании.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ОтчетКомитентуОСписании КАК ОтчетКомитентуОСписании
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ОтчетКомитентуОСписании.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ОтчетКомитентуОСписании.ПометкаУдаления
	|	И ОтчетКомитентуОСписании.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетПоКомиссииМеждуОрганизациями.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ОтчетПоКомиссииМеждуОрганизациями КАК ОтчетПоКомиссииМеждуОрганизациями
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ОтчетПоКомиссииМеждуОрганизациями.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ОтчетПоКомиссииМеждуОрганизациями.ПометкаУдаления
	|	И ОтчетПоКомиссииМеждуОрганизациями.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтчетПоКомиссииМеждуОрганизациямиОСписании.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании КАК ОтчетПоКомиссииМеждуОрганизациямиОСписании
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ОтчетПоКомиссииМеждуОрганизациямиОСписании.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ОтчетПоКомиссииМеждуОрганизациямиОСписании.ПометкаУдаления
	|	И ОтчетПоКомиссииМеждуОрганизациямиОСписании.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПередачаТоваровМеждуОрганизациями.ГруппаФинансовогоУчета,
	|	ПередачаТоваровМеждуОрганизациями.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию),
	|	ПередачаТоваровМеждуОрганизациями.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ПередачаТоваровМеждуОрганизациями КАК ПередачаТоваровМеждуОрганизациями
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ПередачаТоваровМеждуОрганизациями.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ПередачаТоваровМеждуОрганизациями.ПометкаУдаления
	|	И ПередачаТоваровМеждуОрганизациями.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПриобретениеТоваровУслуг.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ПриобретениеТоваровУслуг.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика)
	|		ИЛИ ПриобретениеТоваровУслуг.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту)
	|		ИЛИ ПриобретениеТоваровУслуг.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ПриобретениеТоваровУслуг.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ПриобретениеТоваровУслуг.ПометкаУдаления
	|	И ПриобретениеТоваровУслуг.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПриобретениеУслугПрочихАктивов.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ПриобретениеУслугПрочихАктивов КАК ПриобретениеУслугПрочихАктивов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ПриобретениеУслугПрочихАктивов.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ПриобретениеУслугПрочихАктивов.ПометкаУдаления
	|	И ПриобретениеУслугПрочихАктивов.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РеализацияТоваровУслуг.ГруппаФинансовогоУчета,
	|	РеализацияТоваровУслуг.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту)
	|		ИЛИ РеализацияТоваровУслуг.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности),
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = РеализацияТоваровУслуг.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ РеализацияТоваровУслуг.ПометкаУдаления
	|	И РеализацияТоваровУслуг.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РеализацияУслугПрочихАктивов.ГруппаФинансовогоУчета,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.РеализацияУслугПрочихАктивов КАК РеализацияУслугПрочихАктивов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = РеализацияУслугПрочихАктивов.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ РеализацияУслугПрочихАктивов.ПометкаУдаления
	|	И РеализацияУслугПрочихАктивов.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаможеннаяДекларацияИмпорт.ГруппаФинансовогоУчета,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	Документ.ТаможеннаяДекларацияИмпорт КАК ТаможеннаяДекларацияИмпорт
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ПО (ОбъектыДляОбработки.Ссылка = ТаможеннаяДекларацияИмпорт.ГруппаФинансовогоУчета)
	|ГДЕ
	|	НЕ ТаможеннаяДекларацияИмпорт.ПометкаУдаления
	|	И ТаможеннаяДекларацияИмпорт.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоНакладным)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОбъектыДляОбработки.Ссылка КАК Ссылка,
	|	ОбъектыДляОбработки.Ссылка.ВерсияДанных КАК ВерсияДанных,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РасчетыСКлиентами, ИСТИНА)) КАК РасчетыСКлиентами,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РасчетыСПоставщиками, ЛОЖЬ)) КАК РасчетыСПоставщиками,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РасчетыСКомиссионерами, ЛОЖЬ)) КАК РасчетыСКомиссионерами,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РасчетыСКомитентами, ЛОЖЬ)) КАК РасчетыСКомитентами,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РасчетыСКредиторами, ЛОЖЬ)) КАК РасчетыСКредиторами,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РасчетыСДебиторами, ЛОЖЬ)) КАК РасчетыСДебиторами,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.Кредит, ЛОЖЬ)) КАК Кредит,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.Займ, ЛОЖЬ)) КАК Займ,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.Краткосрочный, ЛОЖЬ)) КАК Краткосрочный,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.Долгосрочный, ЛОЖЬ)) КАК Долгосрочный,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.РегламентированнаяВалюта, ЛОЖЬ)) КАК РегламентированнаяВалюта,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.ВалютныйДоговор, ЛОЖЬ)) КАК ВалютныйДоговор,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.Депозит, ЛОЖЬ)) КАК Депозит,
	|	МАКСИМУМ(ЕСТЬNULL(ГФУ.ЗаймВыданный, ЛОЖЬ)) КАК ЗаймВыданный
	|ИЗ
	|	ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ГФУ КАК ГФУ
	|		ПО (ОбъектыДляОбработки.Ссылка = ГФУ.ГруппаФинансовогоУчета)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОбъектыДляОбработки.Ссылка,
	|	ОбъектыДляОбработки.Ссылка.ВерсияДанных";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТОбъектыДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось заблокировать справочник: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									МетаданныеДокумента,
									Выборка.Ссылка,
									ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
		СправочникОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка, Выборка.ВерсияДанных, Параметры.Очередь);
		Если СправочникОбъект = Неопределено Тогда
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		Если Не СправочникОбъект.РасчетыСКлиентами И Не СправочникОбъект.РасчетыСПоставщиками И Не СправочникОбъект.РасчетыСКомиссионерами
			И Не СправочникОбъект.РасчетыСКомитентами И Не СправочникОбъект.РасчетыСКредиторами И Не СправочникОбъект.РасчетыСДебиторами Тогда
			ЗаполнитьЗначенияСвойств(СправочникОбъект, Выборка,, "Ссылка, ВерсияДанных");
		КонецЕсли;
		
		
		Попытка
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать справочник: %Ссылка% по причине: %Причина%'");
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
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
