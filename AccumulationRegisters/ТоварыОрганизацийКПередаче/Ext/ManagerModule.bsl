﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Структура допустимых отборов товаров к передаче {Склад, Организация, ОрганизацияПолучатель, НачалоПериода, КонецПериода}.
//
// Параметры:
//	Отборы - Структура - значения отборов товаров к передаче.
//
// Возвращаемое значение:
//	Структура - допустимые отборы товаров к передаче.
//
Функция ОтборыТоваровКПередаче(Отборы = Неопределено) Экспорт
	ДоступныеПоляОтбора = Новый Структура();
	ДоступныеПоляОтбора.Вставить("Склад", Неопределено);
	ДоступныеПоляОтбора.Вставить("Организация", Неопределено);
	ДоступныеПоляОтбора.Вставить("ОрганизацияПолучатель", Неопределено);
	ДоступныеПоляОтбора.Вставить("НалогообложениеНДС", Неопределено);
	ДоступныеПоляОтбора.Вставить("ТипЗапасов", Неопределено);
	ДоступныеПоляОтбора.Вставить("НачалоПериода", '00010101');
	ДоступныеПоляОтбора.Вставить("КонецПериода", '39991231235959');
	
	Если Неопределено <> Отборы Тогда
		ЗаполнитьЗначенияСвойств(ДоступныеПоляОтбора, Отборы);
	КонецЕсли;
	Возврат ДоступныеПоляОтбора;
КонецФункции

// Перечень (таблица) позиций и количеств к оформлению передач в разрезе измерений регистра товаров к передаче.
//
// Параметры:
//	Отборы - Структура - значения отборов товаров к передаче.
//
// Возвращаемое значение:
//	ТаблицаЗначений - данные для оформления передач товаров.
//
Функция ТоварыКПередаче(Отборы = Неопределено) Экспорт
	ВсеОтборы = ОтборыТоваровКПередаче(Отборы);
	
	НачалоТоваровКПередаче = НачалоТоваровКПередаче(ВсеОтборы.Организация, ВсеОтборы.Склад);
	
	Запрос = Новый Запрос(ТекстОстаткиКПередачеИПотреблению());
	Запрос.УстановитьПараметр("НачалоПериода",
		НачалоМесяца(?(ЗначениеЗаполнено(ВсеОтборы.НачалоПериода), ВсеОтборы.НачалоПериода, НачалоТоваровКПередаче)));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ВсеОтборы.КонецПериода));
	Запрос.УстановитьПараметр("Склад", ВсеОтборы.Склад);
	Запрос.УстановитьПараметр("Организация", ВсеОтборы.Организация);
	Запрос.УстановитьПараметр("ОрганизацияПолучатель", ВсеОтборы.ОрганизацияПолучатель);
	Запрос.УстановитьПараметр("НалогообложениеНДС", ВсеОтборы.НалогообложениеНДС);
	Запрос.УстановитьПараметр("ТипЗапасов", ВсеОтборы.ТипЗапасов);
	Запрос.УстановитьПараметр("ГраницаПериода", Новый Граница(КонецМесяца(ВсеОтборы.КонецПериода), ВидГраницы.Включая));
	Результат = Запрос.Выполнить();
	
	ТоварыКПередаче = Новый ТаблицаЗначений;
	Для Каждого Колонка Из Результат.Колонки Цикл
		Имя = Колонка.Имя;
		Если Имя = "ПериодПрихода" Или Имя = "Передано" Тогда
			Продолжить;
		КонецЕсли;
		ТоварыКПередаче.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	Передано = 0.;
	Потребление = Неопределено;
	Измерение = Новый Структура(
		"НомерГТД, ВидЗапасовПолучателя, Отправитель, Склад, АналитикаУчетаНоменклатуры, Месяц, Потребления");
	Измерение.Потребления = ТоварыКПередаче.СкопироватьКолонки();

	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ИзмерениеИзменилось =
			Измерение.АналитикаУчетаНоменклатуры <> Выборка.АналитикаУчетаНоменклатуры
			Или Измерение.Склад <> Выборка.Склад
			Или Измерение.Отправитель <> Выборка.Отправитель
			Или Измерение.ВидЗапасовПолучателя <> Выборка.ВидЗапасовПолучателя
			Или Измерение.НомерГТД <> Выборка.НомерГТД
			Или Измерение.Месяц <> НачалоМесяца(Выборка.Период);
		Если ИзмерениеИзменилось Тогда
			ДополнитьТоварыКПередаче(ТоварыКПередаче, Измерение.Потребления, Передано, ВсеОтборы);
			
			Передано = 0.;
			Потребление = Неопределено;
			ЗаполнитьЗначенияСвойств(Измерение, Выборка);
			Измерение.Месяц = НачалоМесяца(Выборка.Период);
			Измерение.Потребления.Очистить();
		КонецЕсли;
		
		Если Выборка.Потреблено > Передано Тогда
			Если Потребление = Неопределено Или Выборка.ДатаОформления > Потребление.ДатаОформления Тогда
				Потребление = Измерение.Потребления.Добавить();
				ЗаполнитьЗначенияСвойств(Потребление, Выборка);
				Потребление.Потреблено = 0.;
			КонецЕсли;
			Потребление.Потреблено = Потребление.Потреблено + Выборка.Потреблено - Передано;
			Потребление.Период = Макс(Потребление.Период, Выборка.Период);
			Передано = 0.;
		Иначе
			Передано = Передано + Выборка.Передано - Выборка.Потреблено;
		КонецЕсли;
		
	КонецЦикла;
	ДополнитьТоварыКПередаче(ТоварыКПередаче, Измерение.Потребления, Передано, ВсеОтборы);
	
	Возврат ТоварыКПередаче;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачалоТоваровКПередаче(Организация, Склад)
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ТТ.Период КАК Период,
		|	ТТ.ОрганизацияВладелец,
		|	ТТ.АналитикаУчетаНоменклатуры,
		|	ТТ.ВидЗапасовПродавца,
		|	ТТ.НомерГТД,
		|	ТТ.КоличествоПриход,
		|	ТТ.КоличествоРасход
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизацийКПередаче.Обороты( , , МЕСЯЦ,
		|		&Организация В (НЕОПРЕДЕЛЕНО, ОрганизацияВладелец)
		|	) КАК ТТ
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
		|		ПО Аналитика.КлючАналитики = ТТ.АналитикаУчетаНоменклатуры
		|ГДЕ
		|	ТТ.КоличествоПриход > ТТ.КоличествоРасход
		|	И &Склад В (НЕОПРЕДЕЛЕНО, ВЫРАЗИТЬ(Аналитика.Склад КАК Справочник.Склады))
		|УПОРЯДОЧИТЬ ПО
		|	ТТ.Период
		|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Период, '00010101');
КонецФункции

// Текст запроса остатков к передаче и потреблению на каждый день.
// Поля результата запроса:
//		{Период, ДатаОформления, Отправитель, Получатель, Склад, АналитикаУчетаНоменклатуры,
//		ВидЗапасов, НомерГТД, ВидЗапасовПолучателя, НалогообложениеНДС, ТипЗапасов,
//		Передано, Потреблено}
// Упорядоченность:
//		{Получатель, ВидЗапасовПолучателя, Отправитель, АналитикаУчетаНоменклатуры, НомерГТД, Период}
Функция ТекстОстаткиКПередачеИПотреблению()
	Возврат "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(Расходы.Период, ДЕНЬ) КАК ПериодРасхода,
		|	Расходы.АналитикаУчетаНоменклатуры,
		|	Расходы.ОрганизацияВладелец,
		|	Расходы.ВидЗапасовПродавца,
		|	Расходы.НомерГТД,
		|	МАКСИМУМ(НАЧАЛОПЕРИОДА(Приходы.Период, ДЕНЬ)) КАК ПериодПрихода
		|ПОМЕСТИТЬ
		|	Даты
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизацийКПередаче КАК Расходы
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасовПродавцов
		|		ПО ВидыЗапасовПродавцов.Ссылка = Расходы.ВидЗапасовПродавца
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитики
		|		ПО Аналитики.КлючАналитики = Расходы.АналитикаУчетаНоменклатуры
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизаций КАК Приходы
		|		ПО Приходы.АналитикаУчетаНоменклатуры = Расходы.АналитикаУчетаНоменклатуры
		|		И Приходы.Период <= КОНЕЦПЕРИОДА(Расходы.Период, ДЕНЬ)
		|		И Приходы.Организация = Расходы.ОрганизацияВладелец
		|		И Приходы.ВидЗапасов = ВидыЗапасовПродавцов.ВидЗапасовВладельца
		|		И Приходы.НомерГТД = Расходы.НомерГТД
		|ГДЕ
		|	Расходы.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И Приходы.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И (Приходы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) ИЛИ Приходы.Количество < 0.)
		|	И &Организация В (НЕОПРЕДЕЛЕНО, Расходы.ОрганизацияВладелец)
		|	И &ОрганизацияПолучатель В (НЕОПРЕДЕЛЕНО, ВидыЗапасовПродавцов.Организация)
		|	И &Склад В (НЕОПРЕДЕЛЕНО, ВЫРАЗИТЬ(Аналитики.Склад КАК Справочник.Склады))
		|	И &НалогообложениеНДС В (НЕОПРЕДЕЛЕНО, ВидыЗапасовПродавцов.НалогообложениеНДС)
		|	И &ТипЗапасов В (НЕОПРЕДЕЛЕНО, ВидыЗапасовПродавцов.ТипЗапасов)
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(Расходы.Период, ДЕНЬ),
		|	Расходы.АналитикаУчетаНоменклатуры,
		|	Расходы.ОрганизацияВладелец,
		|	Расходы.ВидЗапасовПродавца,
		|	Расходы.НомерГТД
		|;
		|
		|ВЫБРАТЬ
		|	ДД.Период,
		|	(ВЫБОР
		|		КОГДА ЕСТЬNULL(Даты.ПериодПрихода, &НачалоПериода) <= НАЧАЛОПЕРИОДА(ДД.Период, МЕСЯЦ) ТОГДА НАЧАЛОПЕРИОДА(ДД.Период, МЕСЯЦ)
		|		КОГДА Даты.ПериодПрихода = ДД.Период ТОГДА ДД.Период
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(Даты.ПериодПрихода, ДЕНЬ, 1) КОНЕЦ) КАК ДатаОформления,
		|	ДД.ОрганизацияВладелец КАК Отправитель,
		|	ВидыЗапасовПродавцов.Организация КАК Получатель,
		|	Аналитики.Склад,
		|	ДД.АналитикаУчетаНоменклатуры,
		|	ВидыЗапасовПродавцов.ВидЗапасовВладельца КАК ВидЗапасов,
		|	ДД.НомерГТД,
		|	ДД.ВидЗапасовПродавца КАК ВидЗапасовПолучателя,
		|	ВидыЗапасовПродавцов.НалогообложениеНДС,
		|	ВидыЗапасовПродавцов.ТипЗапасов,
		|	(ВЫБОР
		|		КОГДА ДД.КоличествоРасход > ДД.КоличествоПриход ТОГДА ДД.КоличествоРасход - ДД.КоличествоПриход
		|		ИНАЧЕ 0. КОНЕЦ) КАК Передано,
		|	(ВЫБОР
		|		КОГДА ДД.КоличествоПриход > ДД.КоличествоРасход ТОГДА ДД.КоличествоПриход - ДД.КоличествоРасход
		|		ИНАЧЕ 0. КОНЕЦ) КАК Потреблено
		|ИЗ
		|	РегистрНакопления.ТоварыОрганизацийКПередаче.Обороты(
		|		&НачалоПериода, &КонецПериода, ДЕНЬ, &Организация В (НЕОПРЕДЕЛЕНО, ОрганизацияВладелец)
		|	) КАК ДД
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК ВидыЗапасовПродавцов
		|		ПО ВидыЗапасовПродавцов.Ссылка = ДД.ВидЗапасовПродавца
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитики
		|		ПО Аналитики.КлючАналитики = ДД.АналитикаУчетаНоменклатуры
		|	ЛЕВОЕ СОЕДИНЕНИЕ Даты КАК Даты
		|		ПО Даты.ПериодРасхода = ДД.Период
		|		И Даты.АналитикаУчетаНоменклатуры = ДД.АналитикаУчетаНоменклатуры
		|		И Даты.ОрганизацияВладелец = ДД.ОрганизацияВладелец
		|		И Даты.ВидЗапасовПродавца = ДД.ВидЗапасовПродавца
		|		И Даты.НомерГТД = ДД.НомерГТД
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыОрганизацийКПередаче.Остатки(&ГраницаПериода) КАК ОстаткиНаКонец
		|	ПО ДД.ОрганизацияВладелец = ОстаткиНаКонец.ОрганизацияВладелец
		|		И ДД.АналитикаУчетаНоменклатуры = ОстаткиНаКонец.АналитикаУчетаНоменклатуры
		|		И ДД.ВидЗапасовПродавца = ОстаткиНаКонец.ВидЗапасовПродавца
		|		И ДД.НомерГТД = ОстаткиНаКонец.НомерГТД
		|
		|ГДЕ
		|	ДД.КоличествоРасход <> ДД.КоличествоПриход
		|	И &ОрганизацияПолучатель В (НЕОПРЕДЕЛЕНО, ВидыЗапасовПродавцов.Организация)
		|	И &Склад В (НЕОПРЕДЕЛЕНО, ВЫРАЗИТЬ(Аналитики.Склад КАК Справочник.Склады))
		|	И &НалогообложениеНДС В (НЕОПРЕДЕЛЕНО, ВидыЗапасовПродавцов.НалогообложениеНДС)
		|	И &ТипЗапасов В (НЕОПРЕДЕЛЕНО, ВидыЗапасовПродавцов.ТипЗапасов)
		|	И ОстаткиНаКонец.КоличествоОстаток <> 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидыЗапасовПродавцов.Организация,
		|	ДД.ВидЗапасовПродавца,
		|	ДД.ОрганизацияВладелец,
		|	ДД.АналитикаУчетаНоменклатуры,
		|	ДД.НомерГТД,
		|	ДД.Период
		|";
КонецФункции

Процедура ДополнитьТоварыКПередаче(ТоварыКПередаче, Потребления, Передано, ВсеОтборы)
	Для Каждого Потребление Из Потребления Цикл
		Если Передано > 0. Тогда
			Потреблено = Мин(Потребление.Потреблено, Передано);
			Потребление.Потреблено = Потребление.Потреблено - Потреблено;
			Передано = Передано - Потреблено;
		КонецЕсли;
		Если Потребление.Потреблено > 0.
			И Потребление.ДатаОформления >= ВсеОтборы.НачалоПериода
			И Потребление.ДатаОформления <= ВсеОтборы.КонецПериода
		Тогда
			ТоварКПередаче = ТоварыКПередаче.Добавить();
			ЗаполнитьЗначенияСвойств(ТоварКПередаче, Потребление);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецЕсли