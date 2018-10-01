﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
// Функция формирует временные таблицы с данными документа.
// Используется для заполнения видов запасов.
//
// Возвращаемое значение:
//	МенеджерВременныхТаблиц - менеджер временных таблиц
//
Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Организация КАК Организация,
	|	&Дата КАК Дата,
	|	&Склад КАК Склад,
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&ВидДеятельностиНДС КАК НалогообложениеНДС,
	|
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваров) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ВтТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки,
	|	ТаблицаТоваров.Номенклатура,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ТаблицаТоваров.Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Перечисление.СтавкиНДС.ПустаяСсылка) КАК СтавкаНДС,
	|	0 КАК СуммаСНДС,
	|	0 КАК СуммаНДС,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	ВтТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Серия КАК Серия,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ТаблицаВидыЗапасов
	|ИЗ
	|	ВтВидыЗапасов КАК ТаблицаВидыЗапасов
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
	|	ПО ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	АналитикаУчетаНоменклатуры,
	|	Аналитика.Номенклатура,
	|	Аналитика.Характеристика,
	|	Аналитика.Серия
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ВидДеятельностиНДС", ВидДеятельностиНДС);
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

// Процедура формирует временную таблицу товаров с аналитикой обособленного учета.
//
// Параметры:
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц	 - менеджер временных таблиц, который будет содержать созданную таблицу.
//
Процедура СформироватьВременнуюТаблицуТоваровИАналитики(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Характеристика,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТоваров.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТоваров.Склад,
	|
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка) КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|
	|	ТаблицаТоваров.Количество КАК Количество
	|	
	|ПОМЕСТИТЬ ТаблицаТоваровИАналитики
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаТоваров
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокумента КАК ТаблицаДанныхДокумента
	|	ПО
	|		Истина
	|;
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

// Процедура заполняет табличную часть документа по остаткам к оформлению излишков и недостач.
//
// Параметры:
//  ДокументОснование	 - ДокументСсылка.ПересчетТоваров, ДокументСсылка.ОрдерНаОтражениеНедостачТоваров - основание для заполнения.
//
Процедура ЗаполнитьТабличнуюЧастьТовары(ДокументОснование = Неопределено) Экспорт

	Запрос = Новый Запрос;
	
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад);
	
	Если ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда 

		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТоварыКОформлению.Номенклатура КАК Номенклатура,
		|	ТоварыКОформлению.Характеристика КАК Характеристика,
		|	ТоварыКОформлению.Назначение КАК Назначение,
		|	ТоварыКОформлению.Серия КАК Серия,
		|	СУММА(ТоварыКОформлению.КОформлениюАктовОстаток) КАК Количество
		|ПОМЕСТИТЬ ТоварыКОформлению
		|ИЗ
		|	(ВЫБРАТЬ
		|		ТоварыКОформлению.Номенклатура КАК Номенклатура,
		|		ТоварыКОформлению.Характеристика КАК Характеристика,
		|		ТоварыКОформлению.Назначение КАК Назначение,
		|		ТоварыКОформлению.Серия КАК Серия,
		|		-ТоварыКОформлению.КОформлениюАктовОстаток КАК КОформлениюАктовОстаток
		|	ИЗ
		|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(, Склад = &Склад) КАК ТоварыКОформлению
		|	ГДЕ
		|		ТоварыКОформлению.КОформлениюАктовОстаток < 0
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыКОформлению.Номенклатура,
		|		ТоварыКОформлению.Характеристика,
		|		ТоварыКОформлению.Назначение,
		|		ТоварыКОформлению.Серия,
		|		ТоварыКОформлению.КОформлениюАктов
		|	ИЗ
		|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыКОформлению
		|	ГДЕ
		|		ТоварыКОформлению.Регистратор = &СписаниеНедостачТоваров
		|		И ТоварыКОформлению.Активность = ИСТИНА) КАК ТоварыКОформлению
		|
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Назначение,
		|	ТоварыКОформлению.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТоварыКОформлению.Номенклатура,
		|	ТоварыКОформлению.Характеристика,
		|	ТоварыКОформлению.Серия,
		|	ТоварыКОформлению.Назначение,
		|	ТоварыКОформлению.Количество
		|ИЗ
		|	ТоварыКОформлению КАК ТоварыКОформлению
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
		|		ПО (&НаОснованииПересчета)
		|			И ТоварыКОформлению.Номенклатура = ПересчетТоваровТовары.Номенклатура
		|			И ТоварыКОформлению.Характеристика = ПересчетТоваровТовары.Характеристика
		|			И ТоварыКОформлению.Назначение = ПересчетТоваровТовары.Назначение
		|			И (ПересчетТоваровТовары.СтатусУказанияСерий <> 14
		|				ИЛИ ТоварыКОформлению.Серия = ПересчетТоваровТовары.Серия)
		|			И (ПересчетТоваровТовары.Количество <> ПересчетТоваровТовары.КоличествоФакт)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ОрдерНаОтражениеНедостачТоваровТовары
		|		ПО (&НаОснованииОрдера)
		|			И ТоварыКОформлению.Номенклатура = ОрдерНаОтражениеНедостачТоваровТовары.Номенклатура
		|			И ТоварыКОформлению.Характеристика = ОрдерНаОтражениеНедостачТоваровТовары.Характеристика
		|			И ТоварыКОформлению.Назначение = ОрдерНаОтражениеНедостачТоваровТовары.Назначение
		|			И (ОрдерНаОтражениеНедостачТоваровТовары.СтатусУказанияСерий <> 14
		|				ИЛИ ТоварыКОформлению.Серия = ОрдерНаОтражениеНедостачТоваровТовары.Серия)
		|ГДЕ
		|	(НЕ &НаОснованииПересчета
		|			ИЛИ &НаОснованииПересчета
		|				И НЕ ПересчетТоваровТовары.Номенклатура ЕСТЬ NULL 
		|				И ПересчетТоваровТовары.Ссылка = &ДокументОснование)
		|	И (НЕ &НаОснованииОрдера
		|			ИЛИ &НаОснованииОрдера
		|				И НЕ ОрдерНаОтражениеНедостачТоваровТовары.Номенклатура ЕСТЬ NULL 
		|				И ОрдерНаОтражениеНедостачТоваровТовары.Ссылка = &ДокументОснование)";
		
		Запрос.УстановитьПараметр("СписаниеНедостачТоваров", Ссылка);
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		НаОснованииПересчета = ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПересчетТоваров");
		Запрос.УстановитьПараметр("НаОснованииПересчета", НаОснованииПересчета);
		НаОснованииОрдера = ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОрдерНаОтражениеНедостачТоваров");
		Запрос.УстановитьПараметр("НаОснованииОрдера", НаОснованииОрдера);
		
	Иначе
		
		// На неордерном складе ДокументОснование будет только пересчет
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПересчетТоваровТовары.Номенклатура,
		|	ПересчетТоваровТовары.Характеристика,
		|	ПересчетТоваровТовары.Назначение,
		|	ПересчетТоваровТовары.Серия,
		|	ПересчетТоваровТовары.Количество - ПересчетТоваровТовары.КоличествоФакт КАК Количество
		|ИЗ
		|	Документ.ПересчетТоваров.Товары КАК ПересчетТоваровТовары
		|ГДЕ
		|	ПересчетТоваровТовары.Ссылка = &Ссылка
		|	И ПересчетТоваровТовары.Количество - ПересчетТоваровТовары.КоличествоФакт > 0";
		
		Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
		
	КонецЕсли;
		
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если Не Результат.Пустой() Тогда

		Товары.Загрузить(Результат.Выгрузить());
		
	ИначеЕсли ЗначениеЗаполнено(ДокументОснование) Тогда  

		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить списание.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДокументОснование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.СписаниеТоваров, Склад, Подразделение, Неопределено);
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДокументОснование = Неопределено;
	ЗаполнитьТабличнуюЧастьТовары = Истина;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("АктОРасхождениях") 
			И ДанныеЗаполнения.Свойство("ОснованиеАкта") Тогда
			
			ЗаполнитьДокументНаОснованииАктаПриемки(ДанныеЗаполнения);
			ДокументОснование = ДанныеЗаполнения.АктОРасхождениях;
			ЗаполнитьТабличнуюЧастьТовары = Ложь;

		Иначе
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
			ЗаполнитьТабличнуюЧастьТовары = НЕ ДанныеЗаполнения.Свойство("НеЗаполнятьТаблинуюЧастьТовары");
			
		КонецЕсли;
		
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ДанныеЗаполнения))
		И ДанныеЗаполнения <> Неопределено Тогда 	
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПересчетТоваров") Тогда 
			СтруктураРезультат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Статус, Склад");
			Если СтруктураРезультат.Статус <> Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда 
				ТекстСообщения = НСтр("ru='Документ ""%ДокументПересчет%"" находится в статусе ""%СтатусПересчета%"". Ввод документа ""%ДокументАкт%"" на основании разрешен только в статусе ""%СтатусВыполнено%"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументПересчет%", ДанныеЗаполнения);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументАкт%", Метаданные.Документы.СписаниеНедостачТоваров.Синоним);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусВыполнено%", Перечисления.СтатусыПересчетовТоваров.Выполнено);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусПересчета%", СтруктураРезультат.Статус);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			Склад = СтруктураРезультат.Склад;
			ПересчетТоваров = ДанныеЗаполнения;
		КонецЕсли;
				
		Если Не ЗначениеЗаполнено(Склад) Тогда
			Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Склад");	
		КонецЕсли;
		
		ДокументОснование = ДанныеЗаполнения;
				
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ОтветственныеЛицаСервер.ОтветственныеЛицаДокументаОбработкаЗаполнения(Ссылка, ДанныеЗаполнения, СтандартнаяОбработка);
	ЗаполнениеСвойствПоСтатистикеСервер.ЗаполнитьСвойстваОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если ЗаполнитьТабличнуюЧастьТовары Тогда 
		ЗаполнитьТабличнуюЧастьТовары(ДокументОснование);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
														НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СписаниеНедостачТоваров));

	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ
		И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СписаниеНедостачТоваров),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,, МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.СписаниеНедостачТоваров.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьРезервыТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизацийКПередаче(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюИзлишковНедостач(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьОбеспечениеЗаказов(ДополнительныеСвойства, Движения, Отказ);	
	
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияНоменклатураДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();
	
	ЗапасыСервер.ПодготовитьЗаписьТоваровОрганизаций(ЭтотОбъект, РежимЗаписиДокумента.ОтменаПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
	ЗапасыСервер.СформироватьРезервыПоТоварамОрганизаций(ЭтотОбъект, Отказ, ПараметрыЗаполнения);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ЗаписатьПодчиненныеНаборамЗаписейДанные(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();
	
	ОтветственныеЛицаСервер.ОтветственныеЛицаДокументаПриКопировании(Ссылка, ОбъектКопирования);
	
	Если ВидыЗапасов.Количество() > 0 Тогда
		ВидыЗапасов.Очистить();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();

	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если Не ЗначениеЗаполнено(ИсточникИнформацииОЦенахДляПечати) Тогда 
		ИсточникИнформацииОЦенахДляПечати = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ИсточникИнформацииОЦенахДляПечати");
		Если НЕ ЗначениеЗаполнено(ИсточникИнформацииОЦенахДляПечати) И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
			ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости;
		КонецЕсли;
		Если ИсточникИнформацииОЦенахДляПечати = Перечисления.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости Тогда
			ВидЦены = Неопределено;
		Иначе
			ВидЦены = Справочники.Склады.УчетныйВидЦены(Склад);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииАктаПриемки(ДанныеЗаполнения)

	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(ДанныеЗаполнения.Склад);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемки.Организация КАК Организация,
	|	АктОРасхожденияхПослеПриемки.Менеджер КАК Ответственный,
	|	АктОРасхожденияхПослеПриемки.Подразделение КАК Подразделение,
	|	&Склад КАК Склад,
	|	&Основание КАК Основание
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки КАК АктОРасхожденияхПослеПриемки
	|ГДЕ
	|	АктОРасхожденияхПослеПриемки.Ссылка = &АктОРасхождениях
	|;";
	
	Запрос.УстановитьПараметр("АктОРасхождениях", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад",            ДанныеЗаполнения.Склад);
	Запрос.УстановитьПараметр("Основание",        ДанныеЗаполнения.ОснованиеАкта);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	КонецЕсли;
	
	//Заполнение ТЧ
	
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	АктОРасхожденияхПослеПриемкиТовары.Номенклатура,
		|	АктОРасхожденияхПослеПриемкиТовары.Характеристика,
		|	АктОРасхожденияхПослеПриемкиТовары.Назначение,
		|	АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу - АктОРасхожденияхПослеПриемкиТовары.Количество КАК Количество,
		|	АктОРасхожденияхПослеПриемкиТовары.Серия,
		|	АктОРасхожденияхПослеПриемкиТовары.СтатусУказанияСерий
		|ИЗ
		|	Документ.АктОРасхожденияхПослеПриемки.Товары КАК АктОРасхожденияхПослеПриемкиТовары
		|ГДЕ
		|	АктОРасхожденияхПослеПриемкиТовары.Ссылка = &Ссылка
		|	И АктОРасхожденияхПослеПриемкиТовары.ДокументОснование = &Основание
		|	И АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу - АктОРасхожденияхПослеПриемкиТовары.Количество > 0
		|	И АктОРасхожденияхПослеПриемкиТовары.Склад = &Склад
		|	И АктОРасхожденияхПослеПриемкиТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы)
		|
		|УПОРЯДОЧИТЬ ПО
		|	АктОРасхожденияхПослеПриемкиТовары.НомерСтроки";
		
	Запрос.УстановитьПараметр("Склад", ДанныеЗаполнения.Склад);
	Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.АктОРасхождениях);

	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	Если Не Результат.Пустой() Тогда

		Товары.Загрузить(Результат.Выгрузить());
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.АктОРасхождениях) Тогда  

		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить списание.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДанныеЗаполнения.АктОРасхождениях);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	 ИЛИ ЗапасыСервер.ПроверитьИзменениеТоваровПоКоличеству(МенеджерВременныхТаблиц) Тогда
		
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД", "Количество");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	// Контроль при перепроведении и отмене проведения

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Склад";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПараметрыЗаполненияВидовЗапасов()
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.НалогообложениеНДС = ВидДеятельностиНДС;
	
	Возврат ПараметрыЗаполнения; 
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
