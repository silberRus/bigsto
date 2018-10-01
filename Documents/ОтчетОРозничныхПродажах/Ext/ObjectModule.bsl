﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ВидыЗапасов.Очистить();
	Серии.Очистить();
	ЕстьМаркируемаяПродукцияГИСМ = Ложь;
	
	СкидкиНаценкиСервер.ОчиститьСкидкиВТЧ(ЭтотОбъект, "Товары");
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		
	Иначе
		
		КассаККМ = Справочники.КассыККМ.АвтономнаяКассаККМПоУмолчанию();
		Если КассаККМ <> Неопределено Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	ПодарочныеСертификатыСервер.ЗаполнитьСуммуВВалютеСертификатаВТабличнойЧасти(ПодарочныеСертификаты, Дата, Валюта);
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
															НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОРозничныхПродажах));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
																
		ЗаполнитьАналитикиУчетаНоменклатуры();
		ЗаполнитьВидыЗапасов(Отказ);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Товары);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ВидыЗапасов);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ОплатаПлатежнымиКартами);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ПодарочныеСертификаты);
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		Если Не ВидыЗапасовУказаныВручную Тогда
			ВидыЗапасов.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	// ИнтеграцияГИСМ
	ЕстьМаркируемаяПродукцияГИСМ = ИнтеграцияГИСМ_УТ.ЕстьМаркируемаяПродукцияГИСМ(Товары);
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Документы.СчетФактураВыданныйАванс.СформироватьДвиженияПоКнигамПокупокПродаж(Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ОтчетОРозничныхПродажах.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыОрганизацийКПередаче(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьРезервыТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыКОформлениюОтчетовКомитента(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьУслугиКОформлениюОтчетовПринципалу(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДоходыИРасходыСервер.ОтразитьВыручкуИСебестоимостьПродаж(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыПоЭквайрингу(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВПути(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваВКассахККМ(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	// Подарочные сертификаты
	ПодарочныеСертификатыСервер.ОтразитьПодарочныеСертификаты(ДополнительныеСвойства, Движения, Отказ);
	ПодарочныеСертификатыСервер.ОтразитьИсториюПодарочныхСертификатов(ДополнительныеСвойства, Движения, Отказ);
	СкидкиНаценкиСервер.ОтразитьБонусныеБаллы(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	ДоходыИРасходыСервер.ОтразитьНДСЗаписиКнигиПродаж(ДополнительныеСвойства, Движения, Отказ);
	
	ЗатратыСервер.ОтразитьМатериалыИРаботыВПроизводстве(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
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
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры // ОбработкаУдаленияПроведения()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОРозничныхПродажах),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	
	Если Не ПоРезультатамИнвентаризации Тогда
		ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоУпаковок");
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТЗНоменклатура.Номенклатура,
		|	ТЗНоменклатура.НомерСтроки
		|ПОМЕСТИТЬ ТЗНоменклатура
		|ИЗ
		|	&ТЗНоменклатура КАК ТЗНоменклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЗНоменклатура.Номенклатура,
		|	ТЗНоменклатура.НомерСтроки
		|ИЗ
		|	ТЗНоменклатура КАК ТЗНоменклатура
		|ГДЕ
		|	ТЗНоменклатура.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)");
		
		Запрос.УстановитьПараметр("ТЗНоменклатура", Товары.Выгрузить(,"Номенклатура, НомерСтроки"));
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
		
			ТекстОшибки = СтрШаблон(НСтр("ru='В режиме заполнения документа ""По результатам инвентаризации"" услуг в списке ""Товары"" быть не должно.
			                                 |Обнаружена услуга в строке %1 списка ""Товары""'"), Выборка.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Номенклатура"),
				,
				Отказ);
		
		КонецЦикла;
		
	КонецЕсли;
	
	СуммаОплатыПлатежнымиКартами = ОплатаПлатежнымиКартами.Итог("Сумма");
	Если ОплатаПлатежнымиКартами.Количество() > 0
		И СуммаОплатыПлатежнымиКартами <> 0
		И СуммаОплатыПлатежнымиКартами > ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС) Тогда
		
		ТекстОшибки = НСтр("ru='Сумма оплаты платежными картами превышает сумму документа'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ОплатаПлатежнымиКартами",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ПоРезультатамИнвентаризации Тогда
		
		КлючевыеРеквизиты = Новый Массив;
		КлючевыеРеквизиты.Добавить("Номенклатура");
		КлючевыеРеквизиты.Добавить("Характеристика");
		ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект, "Товары", КлючевыеРеквизиты, Отказ);
		
	КонецЕсли;

	Если НЕ СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Помещение");
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад = ЗначениеНастроекПовтИсп.ПолучитьРозничныйСкладПоУмолчанию(Склад);
	Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	НалогообложениеНДС = Справочники.Организации.НалогообложениеНДС(
		Организация,
		Склад,
		Дата);
	
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	ОрганизацияЕГАИС = РозничныеПродажи.ПолучитьОрганизациюЕГАИС(Склад, Организация);
	
КонецПроцедуры // ИнициализироватьДокумент()

// Заполняет отчет о розничных продажах в соответствии с отбором.
//
// Параметры
//  ДанныеЗаполнения - Структура со значениями отбора
//
Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьДокументПоОтбору()

// Заполняет документ по кассе ККМ 
//
Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	РеквизитыКассыККМ = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыКассыККМ);
	
КонецПроцедуры // ЗаполнитьДокументПоКассеККМ()

#КонецОбласти

#Область ВидыЗапасов

Функция ВременныеТаблицыДанныхДокумента() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	&Дата КАК Дата,
	|	&Организация КАК Организация,
	|	&Склад КАК Склад,
	|	Неопределено КАК Партнер,
	|	Неопределено КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияВРозницу) КАК ХозяйственнаяОперация,
	|	Ложь КАК ЕстьСделкиВТабличнойЧасти,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Подразделение
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	КОНЕЦ КАК Подразделение,
	|
	|	ВЫБОР КОГДА СтруктураПредприятия.ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения)
	|		И &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|	ТОГДА
	|		&Менеджер
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
	|	КОНЕЦ КАК Менеджер,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов
	|ПОМЕСТИТЬ ТаблицаДанныхДокумента
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|	ПО
	|		СтруктураПредприятия.Ссылка = &Подразделение
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.Характеристика КАК Характеристика,
	|	ТаблицаТоваров.Серия КАК Серия,
	|	ТаблицаТоваров.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Количество КАК Количество,
	|	&Склад КАК Склад,
	|	ТаблицаТоваров.Партнер КАК Партнер,
	|	ТаблицаТоваров.Продавец КАК Продавец,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка) КАК Назначение,
	|	ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТоваров.Сумма + (ТаблицаТоваров.СуммаНДС * &ЦенаВключаетНДС) КАК СуммаСНДС,
	|	ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	ИСТИНА КАК ПодбиратьВидыЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.НомераГТД.ПустаяСсылка) КАК НомерГТД
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	ТаблицаВидыЗапасов.НомерГТД КАК НомерГТД,
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК СкладОтгрузки,
	|	&Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Партнер КАК Партнер,
	|	ТаблицаВидыЗапасов.Продавец КАК Продавец,
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	0 КАК СуммаВознаграждения,
	|	0 КАК СуммаНДСВознаграждения,
	|	&ВидыЗапасовУказаныВручную КАК ВидыЗапасовУказаныВручную
	|	
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	&ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
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
	|	ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаВидыЗапасов.СкладОтгрузки КАК СкладОтгрузки,
	|	ТаблицаВидыЗапасов.Склад КАК Склад,
	|	ТаблицаВидыЗапасов.Партнер КАК Партнер,
	|	ТаблицаВидыЗапасов.Продавец КАК Продавец,
	|	ТаблицаВидыЗапасов.Сделка КАК Сделка,
	|	ТаблицаВидыЗапасов.Количество КАК Количество,
	|	ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|	ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|	ТаблицаВидыЗапасов.СуммаВознаграждения КАК СуммаВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаНДСВознаграждения КАК СуммаНДСВознаграждения,
	|	ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
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
	|	АналитикаУчетаНоменклатуры
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Менеджер", Ответственный);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.УстановитьПараметр("ЦенаВключаетНДС", ?(ЦенаВключаетНДС, 0, 1));
	Запрос.УстановитьПараметр("ВидыЗапасовУказаныВручную", ВидыЗапасовУказаныВручную);
	Запрос.УстановитьПараметр("ФормироватьВидыЗапасовПоПодразделениямМенеджерам", ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам"));
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары);
	Запрос.УстановитьПараметр("ТаблицаВидыЗапасов", ВидыЗапасов);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	
	Запрос.Выполнить();
	
	Возврат МенеджерВременныхТаблиц;
	
КонецФункции

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
	|	ТаблицаДанныхДокумента.Подразделение,
	|	ТаблицаДанныхДокумента.Менеджер,
	|	ТаблицаТоваров.Назначение КАК Назначение,
	|
	|	ЗНАЧЕНИЕ(Справочник.СделкиСКлиентами.ПустаяСсылка) КАК Сделка,
	|	ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка) КАК Партнер,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	&НалогообложениеНДС КАК НалогообложениеНДС,
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
	|ГДЕ
	|	ТаблицаТоваров.Номенклатура.ТипНоменклатуры В
	|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|;
	|");
	Запрос.УстановитьПараметр("НалогообложениеНДС", НалогообложениеНДС);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	
	ИменаРеквизитов = "Организация, Дата, Склад, НалогообложениеНДС";
	
	Возврат ЗапасыСервер.ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц, Ссылка, ИменаРеквизитов);
	
КонецФункции

Функция ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
	|ИЗ (
	|	ВЫБРАТЬ
	|		ТаблицаТоваров.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаТоваров.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаТоваров.Партнер КАК Партнер,
	|		ТаблицаТоваров.Продавец КАК Продавец,
	|		ТаблицаТоваров.Количество КАК Количество,
	|		ТаблицаТоваров.СуммаСНДС КАК СуммаСНДС,
	|		ТаблицаТоваров.СуммаНДС КАК СуммаНДС,
	|		ТаблицаТоваров.СуммаРучнойСкидки КАК СуммаРучнойСкидки
	|	ИЗ
	|		ТаблицаТоваров КАК ТаблицаТоваров
	|	ГДЕ
	|		ТаблицаТоваров.Номенклатура.ТипНоменклатуры В
	|			(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),
	|			 ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ТаблицаВидыЗапасов.СтавкаНДС КАК СтавкаНДС,
	|		ТаблицаВидыЗапасов.Партнер КАК Партнер,
	|		ТаблицаВидыЗапасов.Продавец КАК Продавец,
	|		-ТаблицаВидыЗапасов.Количество КАК Количество,
	|		-ТаблицаВидыЗапасов.СуммаСНДС КАК СуммаСНДС,
	|		-ТаблицаВидыЗапасов.СуммаНДС КАК СуммаНДС,
	|		-ТаблицаВидыЗапасов.СуммаРучнойСкидки КАК СуммаРучнойСкидки
	|	ИЗ
	|		ТаблицаВидыЗапасов КАК ТаблицаВидыЗапасов
	|	) КАК ТаблицаТоваров
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.Партнер,
	|	ТаблицаТоваров.Продавец
	|
	|ИМЕЮЩИЕ
	|	СУММА(ТаблицаТоваров.Количество) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаСНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаНДС) <> 0
	|	ИЛИ СУММА(ТаблицаТоваров.СуммаРучнойСкидки) <> 0
	|");
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	РезультатЗапрос = Запрос.Выполнить();
	
	Возврат (Не РезультатЗапрос.Пустой());
	
КонецФункции

Процедура ЗаполнитьДопКолонкиВидовЗапасов() Экспорт
	
	ТаблицаТовары = Товары.Выгрузить(, "АналитикаУчетаНоменклатуры, Партнер, Продавец, АналитикаУчетаНаборов, Количество, Сумма, СтавкаНДС, СуммаНДС, СуммаРучнойСкидки");
	ТаблицаТовары.Свернуть("АналитикаУчетаНоменклатуры, Партнер, Продавец, АналитикаУчетаНаборов, СтавкаНДС",
		"Количество, Сумма, СуммаНДС, СуммаРучнойСкидки");

	СтруктураПоиска = Новый Структура("АналитикаУчетаНоменклатуры, Партнер");
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл

		КоличествоТоваров = СтрокаТоваров.Количество;
		СуммаСНДС = ?(ЦенаВключаетНДС, СтрокаТоваров.Сумма, СтрокаТоваров.Сумма + СтрокаТоваров.СуммаНДС);
		СуммаНДС = СтрокаТоваров.СуммаНДС;
		СуммаРучнойСкидки = СтрокаТоваров.СуммаРучнойСкидки;
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТоваров);
		СтруктураПоиска.Партнер = Справочники.Партнеры.ПустаяСсылка();
		Для Каждого СтрокаЗапасов Из ВидыЗапасов.НайтиСтроки(СтруктураПоиска) Цикл

			Если СтрокаЗапасов.Количество = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Количество = Мин(КоличествоТоваров, СтрокаЗапасов.Количество);

			НоваяСтрока = ВидыЗапасов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапасов);
			
			НоваяСтрока.АналитикаУчетаНаборов = СтрокаТоваров.АналитикаУчетаНаборов;
			
			НоваяСтрока.Партнер = СтрокаТоваров.Партнер;
			НоваяСтрока.Продавец = СтрокаТоваров.Продавец;
			НоваяСтрока.Количество = Количество;
			Если Количество >= КоличествоТоваров Тогда
				НоваяСтрока.СуммаСНДС = СуммаСНДС;
				НоваяСтрока.СуммаНДС = СуммаНДС;
			ИначеЕсли СтрокаЗапасов.Количество <> 0 Тогда
				НоваяСтрока.СуммаСНДС = Мин(СуммаСНДС, Количество * СтрокаЗапасов.СуммаСНДС / СтрокаЗапасов.Количество);
				НоваяСтрока.СуммаНДС = Мин(СуммаНДС, Количество * СтрокаЗапасов.СуммаНДС / СтрокаЗапасов.Количество);
			КонецЕсли;
			
			НоваяСтрока.СуммаРучнойСкидки = ?(КоличествоТоваров <> 0, Количество * СуммаРучнойСкидки / КоличествоТоваров, 0);

			СтрокаЗапасов.Количество = СтрокаЗапасов.Количество - НоваяСтрока.Количество;
			СтрокаЗапасов.СуммаСНДС = СтрокаЗапасов.СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СтрокаЗапасов.СуммаНДС = СтрокаЗапасов.СуммаНДС - НоваяСтрока.СуммаНДС;
			СтрокаЗапасов.СуммаРучнойСкидки = СтрокаЗапасов.СуммаРучнойСкидки - НоваяСтрока.СуммаРучнойСкидки;
			
			КоличествоТоваров = КоличествоТоваров - НоваяСтрока.Количество;
			СуммаСНДС = СуммаСНДС - НоваяСтрока.СуммаСНДС;
			СуммаНДС = СуммаНДС - НоваяСтрока.СуммаНДС;
			СуммаРучнойСкидки = СуммаРучнойСкидки - НоваяСтрока.СуммаРучнойСкидки;

			Если КоличествоТоваров = 0 Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;
		
	КонецЦикла;
	
	МассивУдаляемыхСтрок = ВидыЗапасов.НайтиСтроки(Новый Структура("Количество", 0));
	Для Каждого СтрокаТаблицы Из МассивУдаляемыхСтрок Цикл
		ВидыЗапасов.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьВидыЗапасов(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = ВременныеТаблицыДанныхДокумента();
	ПерезаполнитьВидыЗапасов = ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект);
	Если Не Проведен
	 ИЛИ ПерезаполнитьВидыЗапасов
	 ИЛИ ПроверитьИзменениеРеквизитовДокумента(МенеджерВременныхТаблиц)
	 ИЛИ ПроверитьИзменениеТоваров(МенеджерВременныхТаблиц) Тогда
	 
		ПараметрыЗаполнения = ПараметрыЗаполненияВидовЗапасов();
		
		ЗапасыСервер.ЗаполнитьВидыЗапасовПоТоварамОрганизаций(ЭтотОбъект, МенеджерВременныхТаблиц, Отказ, ПараметрыЗаполнения);
		
		ВидыЗапасов.Свернуть("АналитикаУчетаНоменклатуры, ВидЗапасов, НомерГТД, СтавкаНДС", "Количество, СуммаСНДС, СуммаНДС");
		ЗаполнитьДопКолонкиВидовЗапасов();
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет аналитики учета номенклатуры. Используется в отчете ОстаткиТоваровОрганизаций.
Процедура ЗаполнитьАналитикиУчетаНоменклатуры() Экспорт
	
	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Неопределено, Склад, Подразделение, Неопределено);
	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
	ИменаПолей.Назначение = "";
	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
	РегистрыСведений.АналитикаУчетаНаборов.ЗаполнитьВКоллекции(Товары);

КонецПроцедуры

#КонецОбласти

#Область Прочее

// Процедура формирует список регистров для контроля.
// Список регистров хранится в ДополнительныеСвойства.ДляПроведения.РегистрыДляКонтроля
//
Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если Не ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект) Тогда
		
		// Контроль выполняется при проведении\отмене проведения не нового документа.
		Если Не ДополнительныеСвойства.ЭтоНовый Тогда
			// Приходы в регистр (сторно расхода из регистра) контролируем при перепроведении и отмене проведения
			Массив.Добавить(Движения.ТоварыОрганизаций);
		КонецЕсли;
		
		Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			
			Массив.Добавить(Движения.СвободныеОстатки);
			
			Если НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОтчетОРозничныхПродажах).ИспользоватьСерииНоменклатуры Тогда
				Массив.Добавить(Движения.ТоварыНаСкладах);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры // СформироватьСписокРегистровДляКонтроля()

Функция ПараметрыЗаполненияВидовЗапасов()
	ПараметрыЗаполнения = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	ПараметрыЗаполнения.ОтборыВидовЗапасов.НалогообложениеНДС = НалогообложениеНДС;
	
	Возврат ПараметрыЗаполнения; 
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
