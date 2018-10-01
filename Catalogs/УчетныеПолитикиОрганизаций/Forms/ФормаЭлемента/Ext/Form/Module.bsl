﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ПериодУчетнойПолитики = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПериодУчетнойПолитики", '000101010000');
	
	
	ПрименяетсяУСН = Объект.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
	ПрименяетсяУСНДоходыМинусРасходы = Объект.ОбъектНалогообложенияУСН = Перечисления.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы;
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВариантУчетаСтоимостиПродукции = ?(Объект.УчетГотовойПродукцииПоПлановойСтоимости, "ПоПлановой", "ПоФактической");
	
	УстановитьВидимостьЭлементов();
	
	СтатьяРасходовНеНДСПриИзмененииНаСервере();
	СтатьяРасходовЕНВДПриИзмененииНаСервере();
	
// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
// Конец СтандартныеПодсистемы.Свойства

// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	
// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УчетныеПолитикиОрганизаций", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ЭтотОбъект.Модифицированность Тогда
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СистемаНалогообложенияПриИзменении(Элемент)
	
	ПрименяетсяУСН = Объект.СистемаНалогообложения = ПредопределенноеЗначение("Перечисление.СистемыНалогообложения.Упрощенная");
	Если ПрименяетсяУСН Тогда
		Объект.ПрименяетсяОсвобождениеОтУплатыНДС = Ложь;
		Объект.ПрименяетсяУчетНДСПоФактическомуИспользованию = Ложь;
		Объект.Учитывать5ПроцентныйПорог = Ложь;
		Объект.ПрименяетсяПБУ18 = Ложь;
		Объект.ФормироватьРезервыПоСомнительнымДолгамНУ = Ложь;
		Если НЕ ЗначениеЗаполнено(Объект.ОбъектНалогообложенияУСН) Тогда
			Объект.ОбъектНалогообложенияУСН = ПредопределенноеЗначение("Перечисление.ОбъектыНалогообложенияПоУСН.Доходы");
			Объект.СтавкаНалогаУСН = 6;
			ПрименяетсяУСНДоходыМинусРасходы = Ложь;
		КонецЕсли;
	Иначе
		Объект.ПрименяетсяПБУ18 = Истина;
		Объект.ДатаПереходаНаУСН = Дата(1,1,1);
	КонецЕсли;
	
	УстановитьСтавкуНалогаУСН();
	
	УстановитьВидимостьЭлементов();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьРезервОтпусковБУПриИзменении(Элемент)
	
	Если Не Объект.ФормироватьРезервОтпусковБУ Тогда
		Объект.ФормироватьРезервОтпусковНУ = Ложь;
		Объект.ОпределятьИзлишкиРезервовОтпусковЕжемесячно = Ложь;
	КонецЕсли;
	
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьРезервОтпусковНУПриИзменении(Элемент)
	
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияРезерваОтпусковПриИзменении(Элемент)
	
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектНалогообложенияУСНПриИзменении(Элемент)
	
	ПрименяетсяУСНДоходыМинусРасходы = Объект.ОбъектНалогообложенияУСН = ПредопределенноеЗначение("Перечисление.ОбъектыНалогообложенияПоУСН.ДоходыМинусРасходы");
	УстановитьСтавкуНалогаУСН();
	УстановитьВидимостьЭлементов();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектНалогообложенияУСНОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПереходаНаУСНПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ДатаПереходаНаУСН) Тогда
		Объект.ДатаПереходаНаУСН = НачалоГода(Объект.ДатаПереходаНаУСН);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтавкаНалогаУСНПриИзменении(Элемент)
	
	// Проверим введенное число:
	// Неотрицательное значение задать нельзя в силу ограничения типа.
	// Положительное - проверяем на превышение максимально допустимой ставки для выбранного объекта налогообложения.
	ПределСтавки = ?(ПрименяетсяУСНДоходыМинусРасходы, 15, 6);
	
	Если Объект.СтавкаНалогаУСН > ПределСтавки Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выбранная ставка не может применяться.
			|Максимально допустимая ставка налога для выбранного объекта налогообложения равна %1 %.'"),
			ПределСтавки);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Объект.СтавкаНалогаУСН = ПределСтавки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МетодОценкиСтоимостиТоваровПриИзменении(Элемент)
	УстановитьВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяЕНВДНалоговыйУчетПриИзменении(Элемент)
	
	УстановитьВидимостьЭлементов();
	УстановитьДоступностьЭлементов();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантУчетаНДСПриИзмененииВидаДеятельностиПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНеНДСПриИзменении(Элемент)
	
	Элементы.АналитикаРасходовНеНДС.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС);
	Если ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС) Тогда
		СтатьяРасходовНеНДСПриИзмененииНаСервере();
	Иначе
		Объект.АналитикаРасходовНеНДС = Неопределено;
		АналитикаРасходовНеНДСОбязательна = Ложь;
		АналитикаРасходовНеНДСЗаказРеализация = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНеНДСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяРасходовНеНДСВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходовНеНДС);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовЕНВДНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяРасходовЕНВДВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходовЕНВД);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовЕНВДПриИзменении(Элемент)
	
	Элементы.АналитикаРасходовЕНВД.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД);
	Если ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД) Тогда
		СтатьяРасходовЕНВДПриИзмененииНаСервере();
	Иначе
		Объект.АналитикаРасходовЕНВД = Неопределено;
		АналитикаРасходовЕНВДОбязательна = Ложь;
		АналитикаРасходовЕНВДЗаказРеализация = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходовНеНДС = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		И АналитикаРасходовНеНДСЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНеНДСОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		И АналитикаРасходовНеНДСЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходовЕНВД = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		И АналитикаРасходовЕНВДЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовЕНВДОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) 
		И АналитикаРасходовЕНВДЗаказРеализация Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВключатьВСоставНалоговыхРасходовЛизинговыеПлатежиПриИзменении(Элемент)
	
	
	Возврат; // В УТ пустой обработчик.
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяОсвобождениеОтУплатыНДСПриИзменении(Элемент)
	
	Если Объект.ПрименяетсяОсвобождениеОтУплатыНДС Тогда
		Объект.ПрименяетсяУчетНДСПоФактическомуИспользованию = Ложь;
		Объект.Учитывать5ПроцентныйПорог = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементов();
	 
КонецПроцедуры

&НаКлиенте
Процедура ВариантУчетаСтоимостиПродукцииПриИзменении(Элемент)
	Модифицированность = Истина;
	Объект.УчетГотовойПродукцииПоПлановойСтоимости = ВариантУчетаСтоимостиПродукции = "ПоПлановой";
	Если НЕ Объект.УчетГотовойПродукцииПоПлановойСтоимости Тогда
		Объект.ИспользоватьСчет40 = Ложь;
	КонецЕсли;
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПрименениеПБУ18ПриИзменении(Элемент)
	
	
	Возврат; // В УТ пустой обработчик.
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	РеквизитыПроверкиАналитик = Новый Массив;
	Если Объект.ПрименяетсяЕНВД Тогда
		РеквизитыПроверкиАналитик.Добавить("СтатьяРасходовНеНДС, АналитикаРасходовНеНДС, СтатьяРасходовЕНВД, АналитикаРасходовЕНВД");
	Иначе
		РеквизитыПроверкиАналитик.Добавить("СтатьяРасходовНеНДС, АналитикаРасходовНеНДС");
	КонецЕсли;
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление, РеквизитыПроверкиАналитик);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ПартионныйУчетВключен = УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВключен();
	
	Элементы.ГруппаУчетГотовойПродукции.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеПроизводством");
	
	Элементы.ГруппаНДС.Видимость = Не ПрименяетсяУСН;
	Элементы.ГруппаУСН.Видимость = ПрименяетсяУСН;
	Элементы.ГруппаНалоговыйУчет.Видимость = Не ПрименяетсяУСН;
	
	ИспользоватьРаздельныйУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРаздельныйУчетПоНалогообложению");
	Элементы.ДекорацияСтатьяРасходовНеНДС.Видимость = ИспользоватьРаздельныйУчет;
	Элементы.ДекорацияСтатьяРасходовЕНВД.Видимость = ИспользоватьРаздельныйУчет;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Элементы.ПрименениеПБУ18.Видимость = Ложь;
		Элементы.ГруппаРезервы.Видимость = Ложь;
		Элементы.ГруппаРасчеты.Видимость = Ложь;
		Элементы.ВключатьВСоставНалоговыхРасходовЛизинговыеПлатежи.Видимость = Ложь;
		Элементы.ГруппаСхемаУчетаВР.Видимость = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		Элементы.МетодОценкиСтоимостиТоваров.Вид = ВидПоляФормы.ПолеНадписи;
	ИначеЕсли НЕ ПартионныйУчетВключен Тогда
		ЭлементСписка = Элементы.МетодОценкиСтоимостиТоваров.СписокВыбора.НайтиПоЗначению(
						Перечисления.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка);
		Если ЭлементСписка <> Неопределено Тогда
			Элементы.МетодОценкиСтоимостиТоваров.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЕсли;
	
	
	Элементы.ГруппаОценочныеОбязательстваИРезервыОтпусков.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ");
	Элементы.ГруппаПроводкиПоРаботникамПояснение.Видимость 			= НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ");
	Элементы.ПроводкиПоРаботникам.Доступность 						= ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ");
	
	Элементы.СтатьяЗатратЕНВД.АвтоОтметкаНезаполненного = Объект.ПрименяетсяЕНВД;
	Элементы.СтатьяЗатратЕНВД.ОтметкаНезаполненного = Объект.ПрименяетсяЕНВД;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	Элементы.ФормироватьРезервыПоСомнительнымДолгамНУ.Доступность = Не ПрименяетсяУСН;
	Элементы.ФормироватьРезервОтпусковНУ.Доступность = Не ПрименяетсяУСН;
	
	Элементы.ИспользованиеСчета40.Доступность = Объект.УчетГотовойПродукцииПоПлановойСтоимости;
	
	Элементы.МетодНачисленияРезерваОтпусков.Доступность                 = Объект.ФормироватьРезервОтпусковБУ;
	Элементы.ГруппаОценочныеОбязательстваИРезервыОтпусковНУ.Доступность = Объект.ФормироватьРезервОтпусковБУ;
	Элементы.ОпределятьИзлишкиРезервовОтпусковЕжемесячноГруппа.Доступность = Объект.ФормироватьРезервОтпусковБУ;
	
	
	Элементы.ГруппаПравилаСписанияНДСПоТоварам.Доступность =
		Объект.ВариантУчетаНДСПриИзмененииВидаДеятельности <> ПредопределенноеЗначение("Перечисление.ВариантыУчетаНДСПриИзмененииВидаДеятельностиНаНеоблагаемую.ВключатьВСтоимость");
	
	Элементы.ГруппаСтатьяРасходовЕНВД.Доступность = Объект.ПрименяетсяЕНВД;
	
	Элементы.УчетНДСПоФактическомуИспользованию.Доступность = НЕ Объект.ПрименяетсяОсвобождениеОтУплатыНДС;
	Элементы.Учитывать5ПроцентныйПорог.Доступность = НЕ Объект.ПрименяетсяОсвобождениеОтУплатыНДС;
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНалогаУСН()

	Если ПрименяетсяУСН Тогда
		Объект.СтавкаНалогаУСН = ?(ПрименяетсяУСНДоходыМинусРасходы, 15, 6);
	Иначе
		Объект.СтавкаНалогаУСН = 0;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовНеНДСПриИзмененииНаСервере()
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		Объект.СтатьяРасходовНеНДС,
		Объект.АналитикаРасходовНеНДС);
		
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СтатьяРасходовНеНДС, "КонтролироватьЗаполнениеАналитики, АналитикаРасходовЗаказРеализация");
	АналитикаРасходовНеНДСОбязательна = ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС) И Реквизиты.КонтролироватьЗаполнениеАналитики;
	АналитикаРасходовНеНДСЗаказРеализация = Реквизиты.АналитикаРасходовЗаказРеализация;
		
	Элементы.АналитикаРасходовНеНДС.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходовНеНДС);
	Элементы.АналитикаРасходовНеНДС.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаРасходовНеНДС)));
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовЕНВДПриИзмененииНаСервере()
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		Объект.СтатьяРасходовЕНВД,
		Объект.АналитикаРасходовЕНВД);
		
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СтатьяРасходовЕНВД, "КонтролироватьЗаполнениеАналитики, АналитикаРасходовЗаказРеализация");
	АналитикаРасходовЕНВДОбязательна = ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД) И Реквизиты.КонтролироватьЗаполнениеАналитики;
	АналитикаРасходовЕНВДЗаказРеализация = Реквизиты.АналитикаРасходовЗаказРеализация;
		
	Элементы.АналитикаРасходовЕНВД.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходовЕНВД);
	Элементы.АналитикаРасходовЕНВД.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаРасходовЕНВД)));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНеНДСВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СтатьяРасходовНеНДС = Результат;
	СтатьяРасходовНеНДСПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовЕНВДВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.СтатьяРасходовЕНВД = Результат;
	СтатьяРасходовЕНВДПриИзмененииНаСервере();
	
КонецПроцедуры


// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
