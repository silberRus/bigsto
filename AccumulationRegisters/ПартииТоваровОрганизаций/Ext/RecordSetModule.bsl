﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
		ИЛИ ОбменДанными.Загрузка
		ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Партии.Период                     КАК Период,
	|	Партии.Регистратор                КАК Регистратор,
	|	Партии.Организация                КАК Организация,
	|	Партии.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Партии.ДокументПоступления        КАК ДокументПоступления,
	|	Партии.ВидЗапасов                 КАК ВидЗапасов,
	|	Партии.АналитикаУчетаПартий       КАК АналитикаУчетаПартий,
	|
	|	Партии.Количество        КАК Количество,
	|	Партии.Стоимость         КАК Стоимость,
	|	Партии.СтоимостьБезНДС   КАК СтоимостьБезНДС,
	|	Партии.СтоимостьРегл     КАК СтоимостьРегл,
	|	Партии.НДСРегл           КАК НДСРегл,
	|	Партии.ПостояннаяРазница КАК ПостояннаяРазница,
	|	Партии.ВременнаяРазница  КАК ВременнаяРазница,
	|
	|	Партии.Номенклатура                  КАК Номенклатура,
	|	Партии.Характеристика                КАК Характеристика,
	|	Партии.НалогообложениеНДС            КАК НалогообложениеНДС,
	|	Партии.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	Партии.КорВидЗапасов                 КАК КорВидЗапасов,
	|	Партии.ДокументИсточник              КАК ДокументИсточник,
	|	Партии.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Партии.Первичное                     КАК Первичное,
	|	Партии.СтатьяРасходовСписания        КАК СтатьяРасходовСписания,
	|	Партии.АналитикаРасходов             КАК АналитикаРасходов
	|ПОМЕСТИТЬ ПартииТоваровПередЗаписью
	|ИЗ
	|	РегистрНакопления.ПартииТоваровОрганизаций КАК Партии
	|ГДЕ
	|	Партии.Регистратор = &Регистратор
	|	И &ПартионныйУчетВключен
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ПартионныйУчетВключен", ДополнительныеСвойства.ДляПроведения.ПартионныйУчетВключен);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ ПланыОбмена.ГлавныйУзел() <> Неопределено
		ИЛИ ОбменДанными.Загрузка
		ИЛИ УниверсальныеМеханизмыПартийИСебестоимости.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ) КАК МЕСЯЦ,
	|	Таблица.Организация                  КАК Организация,
	|	Таблица.Регистратор                  КАК Документ,
	|	ИСТИНА                               КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ПОМЕСТИТЬ ПартииТоваровОрганизацийЗаданияКРасчетуСебестоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		Партии.Период                     КАК Период,
	|		Партии.Регистратор                КАК Регистратор,
	|		Партии.Организация                КАК Организация,
	|		Партии.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Партии.ДокументПоступления        КАК ДокументПоступления,
	|		Партии.ВидЗапасов                 КАК ВидЗапасов,
	|		Партии.АналитикаУчетаПартий       КАК АналитикаУчетаПартий,
	|
	|		Партии.Количество        КАК Количество,
	|		Партии.Стоимость         КАК Стоимость,
	|		Партии.СтоимостьБезНДС   КАК СтоимостьБезНДС,
	|		Партии.СтоимостьРегл     КАК СтоимостьРегл,
	|		Партии.НДСРегл           КАК НДСРегл,
	|		Партии.ПостояннаяРазница КАК ПостояннаяРазница,
	|		Партии.ВременнаяРазница  КАК ВременнаяРазница,
	|
	|		Партии.Номенклатура                  КАК Номенклатура,
	|		Партии.Характеристика                КАК Характеристика,
	|		Партии.НалогообложениеНДС            КАК НалогообложениеНДС,
	|		Партии.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Партии.КорВидЗапасов                 КАК КорВидЗапасов,
	|		Партии.ДокументИсточник              КАК ДокументИсточник,
	|		Партии.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		Партии.Первичное                     КАК Первичное,
	|		Партии.СтатьяРасходовСписания        КАК СтатьяРасходовСписания,
	|		Партии.АналитикаРасходов             КАК АналитикаРасходов
	|	ИЗ
	|		ПартииТоваровПередЗаписью КАК Партии
	|	ГДЕ
	|		&ПартионныйУчетВключен
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Партии.Период                     КАК Период,
	|		Партии.Регистратор                КАК Регистратор,
	|		Партии.Организация                КАК Организация,
	|		Партии.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		Партии.ДокументПоступления        КАК ДокументПоступления,
	|		Партии.ВидЗапасов                 КАК ВидЗапасов,
	|		Партии.АналитикаУчетаПартий       КАК АналитикаУчетаПартий,
	|
	|		-Партии.Количество        КАК Количество,
	|		-Партии.Стоимость         КАК Стоимость,
	|		-Партии.СтоимостьБезНДС   КАК СтоимостьБезНДС,
	|		-Партии.СтоимостьРегл     КАК СтоимостьРегл,
	|		-Партии.НДСРегл           КАК НДСРегл,
	|		-Партии.ПостояннаяРазница КАК ПостояннаяРазница,
	|		-Партии.ВременнаяРазница  КАК ВременнаяРазница,
	|
	|		Партии.Номенклатура                  КАК Номенклатура,
	|		Партии.Характеристика                КАК Характеристика,
	|		Партии.НалогообложениеНДС            КАК НалогообложениеНДС,
	|		Партии.ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|		Партии.КорВидЗапасов                 КАК КорВидЗапасов,
	|		Партии.ДокументИсточник              КАК ДокументИсточник,
	|		Партии.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		Партии.Первичное                     КАК Первичное,
	|		Партии.СтатьяРасходовСписания        КАК СтатьяРасходовСписания,
	|		Партии.АналитикаРасходов             КАК АналитикаРасходов
	|	ИЗ
	|		РегистрНакопления.ПартииТоваровОрганизаций КАК Партии
	|	ГДЕ
	|		Партии.Регистратор = &Регистратор
	|		И &ПартионныйУчетВключен
	|	) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ),
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.ДокументПоступления,
	|	Таблица.ВидЗапасов,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.НалогообложениеНДС,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.КорВидЗапасов,
	|	Таблица.ДокументИсточник,
	|	Таблица.КорАналитикаУчетаНоменклатуры,
	|	Таблица.Первичное,
	|	Таблица.СтатьяРасходовСписания,
	|	Таблица.АналитикаРасходов
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|	ИЛИ СУММА(Таблица.Стоимость) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	ИЛИ СУММА(Таблица.СтоимостьРегл) <> 0
	|	ИЛИ СУММА(Таблица.НДСРегл) <> 0
	|	ИЛИ СУММА(Таблица.ПостояннаяРазница) <> 0
	|	ИЛИ СУММА(Таблица.ВременнаяРазница) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ПартииТоваровПередЗаписью
	|");
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("ИзмененыДанныеДляПартионногоУчетаВерсии21", Истина);
	
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ПартионныйУчетВключен", ДополнительныеСвойства.ДляПроведения.ПартионныйУчетВключен);
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
