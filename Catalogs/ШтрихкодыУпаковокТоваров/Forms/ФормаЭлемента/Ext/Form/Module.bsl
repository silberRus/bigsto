﻿&НаКлиенте
Перем КэшированныеЗначения;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
		ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеФормой(ЭтотОбъект);
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// Неизвестные штрихкоды
	Если Источник = "ПодключаемоеОборудование"
		И ИмяСобытия = "НеизвестныеШтрихкоды"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		КэшированныеЗначения.Штрихкоды.Очистить();
		ДанныеШтрихкодов = Новый Массив;
		Для Каждого ПолученныйШтрихкод Из Параметр.ПолученыНовыеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		Для Каждого ПолученныйШтрихкод Из Параметр.ЗарегистрированныеШтрихкоды Цикл
			ДанныеШтрихкодов.Добавить(ПолученныйШтрихкод);
		КонецЦикла;
		
		ОбработатьШтрихкоды(ДанныеШтрихкодов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораСерии(
		ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипУпаковкиПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТипШтрихкодаПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ТипШтрихкодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипУпаковкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзмененииНаСервере(КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеСвойствПриИзмененииНоменклатуры(КэшЗначений)
	Если НЕ ЗначениеЗаполнено(Объект.Номенклатура) Тогда
		ХарактеристикиИспользуются = Ложь;
		СерииИспользуются = Ложь;
	Иначе
		ХарактеристикиИспользуются = ПризнакИспользованияХарактеристик(Объект.Номенклатура);
		СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	КонецЕсли;
	
	Шапка = Новый Структура("Номенклатура, Характеристика, Серия, СтатусУказанияСерий, Упаковка,
		|Количество, КоличествоУпаковок, ХарактеристикиИспользуются, ТипНоменклатуры, МаркируемаяАлкогольнаяПродукция, ЕдиницаИзмерения");
	ЗаполнитьЗначенияСвойств(Шапка, Объект);
	
	ПараметрыЗаполнения = ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ОбработатьУпаковки = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус = Истина;
	
	СобытияФормЕГАИСПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтотОбъект, Шапка, Неопределено, ПараметрыЗаполнения, ПараметрыУказанияСерий);
	
	ЗаполнитьЗначенияСвойств(Объект, Шапка);
	
	СобытияФормЕГАИСПереопределяемый.УстановитьИнформациюОЕдиницеХранения(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриИзмененииНаСервере(КэшЗначений)
	
	ЗаполнениеСвойствПриИзмененииНоменклатуры(КэшЗначений);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьПодборСерий(Элемент.ТекстРедактирования, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СгенерироватьШтрихкод(Команда)
	
	ЗаполнитьКоличествоНаСервере();
	
	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("ТипУпаковки",    Объект.ТипУпаковки);
	ПередаваемыеПараметры.Вставить("ТипШтрихкода",   Объект.ТипШтрихкода);
	ПередаваемыеПараметры.Вставить("Номенклатура",   Объект.Номенклатура);
	ПередаваемыеПараметры.Вставить("Характеристика", Объект.Характеристика);
	ПередаваемыеПараметры.Вставить("ДатаМаркировки", Объект.ДатаУпаковки);
	Если ЗначениеЗаполнено(Объект.ЗначениеШтрихкода) Тогда
		ПередаваемыеПараметры.Вставить("Штрихкод",   Объект.ЗначениеШтрихкода);
	КонецЕсли;
	ПередаваемыеПараметры.Вставить("КоличествоВложенныхЕдиниц", Объект.Количество);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаГенерацииШтрихкода", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ГенерацияШтрихкодовУпаковок.Форма", ПередаваемыеПараметры, ЭтотОбъект, УникальныйИдентификатор,,,
		ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	ОчиститьСообщения();
	Оповещение = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ДанныеШтрихкодов = Новый Массив;
	ДанныеШтрихкодов.Добавить(ДанныеШтрихкода);
	ОбработатьШтрихкоды(ДанныеШтрихкодов);
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ИнтеграцияЕГАИСКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма, ПараметрыУказанияСерий, Текст, Неопределено)Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом справочнике для указания серий не нужен серверный вызов.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКоличествоНаСервере()
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	СправочникОбъект.РассчитатьКоличествоВложенныхШтрихкодов();
	ЗначениеВРеквизитФормы(СправочникОбъект, "Объект");
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкодыНаКлиенте(ДанныеШтрихкодов, Отказ)
	
	НеСериализуемыйСимвол = ШтрихкодыУпаковокКлиентСервер.СимволОкончанияСтрокиПеременнойДлины();
	
	Для каждого ДанныеШК Из ДанныеШтрихкодов Цикл
		
		Штрихкод = ДанныеШК.Штрихкод;
		Если СтрНайти(Штрихкод, НеСериализуемыйСимвол) <> 0 Тогда
			
			РезультатЧтения = ШтрихкодыУпаковокКлиентСервер.ПараметрыШтрихкода(Штрихкод);
			
			Если НЕ РезультатЧтения.Результат = Неопределено
				И (РезультатЧтения.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128")
					ИЛИ РезультатЧтения.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataBarExpandedStacked")) Тогда
				
				ДанныеШК.Штрихкод = ШтрихкодыУпаковокКлиентСервер.ШтрихкодGS1(РезультатЧтения.Результат, Истина);
				
			ИначеЕсли РезультатЧтения.Результат = Неопределено Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатЧтения.ТекстОшибки,,,,Отказ);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьШтрихкодыНаСервере(ДанныеШтрихкодов, КэшированныеЗначения)
	
	Отказ = Ложь;
	
	Штрихкоды = Новый Массив;
	Для каждого ДанныеШК Из ДанныеШтрихкодов Цикл
		Штрихкоды.Добавить(ДанныеШК.Штрихкод);
	КонецЦикла;
	СписокШтрихкодовУпаковок = Новый Массив;
	Для каждого Строка Из Объект.ВложенныеШтрихкоды Цикл
		СписокШтрихкодовУпаковок.Добавить(Строка.Штрихкод);
	КонецЦикла;
	
	ПараметрыОбработкиШтрихкода = АкцизныеМаркиКлиентСервер.ПараметрыСканированияАкцизныхМарок(ЭтотОбъект);
	ПараметрыОбработкиШтрихкода.СоздаватьШтрихкодУпаковки = Истина;
	РезультатЧтенияШтрихкодов = АкцизныеМаркиЕГАИС.ПолучитьДанныеПоШтрихкодам(Штрихкоды, ПараметрыОбработкиШтрихкода, КэшированныеЗначения);
	
	ПрочитанныеШтрихкоды = Новый Соответствие;
	Для Каждого КлючЗначение Из РезультатЧтенияШтрихкодов.ОбработанныеШтрихкоды Цикл
		ПрочитанныеШтрихкоды.Вставить(КлючЗначение.Значение.Штрихкод, КлючЗначение.Значение.ШтрихкодУпаковки);
	КонецЦикла;
	Для каждого КлючИЗначение Из РезультатЧтенияШтрихкодов.НеобработанныеШтрихкоды Цикл
		ТекстСообщения = НСтр("ru = 'Упаковка или маркированный товар со штрихкодом ""%1"" не найден'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КлючИЗначение.Значение.Штрихкод);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	
	Результат = Справочники.ШтрихкодыУпаковокТоваров.ВложенныеШтрихкодыУпаковок(СписокШтрихкодовУпаковок, Неопределено);
	ДеревоУпаковок = Результат.ДеревоУпаковок;
	
	ПроверкаПрочитанныхУпаковокНаВложенностьВТабличнойЧасти(ДеревоУпаковок.Строки, ПрочитанныеШтрихкоды, Отказ);
	
	Если НЕ Отказ И НЕ ПрочитанныеШтрихкоды = Неопределено Тогда
		Для каждого КлючИЗначение Из ПрочитанныеШтрихкоды Цикл
			Объект.ВложенныеШтрихкоды.Добавить().Штрихкод = КлючИЗначение.Значение;
		КонецЦикла;
	КонецЕсли;
	
	ПараметрыНоменклатуры = Справочники.ШтрихкодыУпаковокТоваров.ПараметрыНоменклатурыВложенныхШтрихкодов(Объект);
	
	ИзменениеТипаУпаковки = Объект.ТипУпаковки <> ПараметрыНоменклатуры.ТипУпаковки;
	ИзменениеНоменклатуры = Объект.Номенклатура <> ПараметрыНоменклатуры.Номенклатура;
	
	Объект.ТипУпаковки    = ПараметрыНоменклатуры.ТипУпаковки;
	Объект.Номенклатура   = ПараметрыНоменклатуры.Номенклатура;
	Объект.Характеристика = ПараметрыНоменклатуры.Характеристика;
	Объект.Упаковка       = ПараметрыНоменклатуры.Упаковка;
	Объект.Серия          = ПараметрыНоменклатуры.Серия;
	
	Если ИзменениеНоменклатуры Тогда
		ЗаполнениеСвойствПриИзмененииНоменклатуры(КэшированныеЗначения);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПроверкаПрочитанныхУпаковокНаВложенностьВТабличнойЧасти(Знач СтрокиДереваУпаковок, ПрочитанныеШтрихкоды, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Если СтрокиДереваУпаковок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаДерева Из СтрокиДереваУпаковок Цикл
		Для каждого КлючИЗначение Из ПрочитанныеШтрихкоды Цикл
			Штрихкод = КлючИЗначение.Ключ;
			ШтрихкодУпаковки = КлючИЗначение.Значение;
			
			Если СтрокаДерева.ЗначениеШтрихкода = Штрихкод Тогда
				Отказ = Истина;
				
				СтрокаВТабличнойЧастиНайдена = Ложь;
				
				НайденныеСтроки = Объект.ВложенныеШтрихкоды.НайтиСтроки(Новый Структура("Штрихкод", СтрокаДерева.ШтрихкодУпаковки));
				Если НайденныеСтроки.Количество() > 0 Тогда
					НайденнаяСтрока = НайденныеСтроки[0];
				КонецЕсли;
				Если НайденнаяСтрока = Неопределено Тогда
					// В табличную часть добавлена паллета, пытаемся добавить вложенный в паллету короб.
					
					РодительСтрокиДерева = СтрокаДерева.Родитель;
					Пока НайденнаяСтрока = Неопределено
					   И НЕ РодительСтрокиДерева = Неопределено Цикл
						НайденныеСтроки = Объект.ВложенныеШтрихкоды.НайтиСтроки(Новый Структура("Штрихкод", РодительСтрокиДерева.ШтрихкодУпаковки));
						Если НайденныеСтроки.Количество() > 0 Тогда
							НайденнаяСтрока = НайденныеСтроки[0];
						КонецЕсли;
						РодительСтрокиДерева = РодительСтрокиДерева.Родитель;
					КонецЦикла;
				КонецЕсли;
				Если НЕ НайденнаяСтрока = Неопределено Тогда
					Поле = "ВложенныеШтрихкоды[" + Формат(Объект.ВложенныеШтрихкоды.Индекс(НайденнаяСтрока), "ЧН=0; ЧГ=0") + "].Штрихкод";
				Иначе
					Поле = "ВложенныеШтрихкоды";
				КонецЕсли;
				ТекстСообщения = НСтр("ru = 'Данный штрихкод ""%1"" уже добавлен в табличную часть или раннее добавленный имеет такой же вложенный штрихкод'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Штрихкод);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле, "Объект", Отказ);
			КонецЕсли;
			Если Отказ Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Отказ Тогда
			Прервать;
		Иначе
			ПроверкаПрочитанныхУпаковокНаВложенностьВТабличнойЧасти(СтрокаДерева.Строки, ПрочитанныеШтрихкоды, Отказ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Не ПустаяСтрока(Объект.ХешСумма) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ОбработатьШтрихкодыНаКлиенте(ДанныеШтрихкодов, Отказ);
	Если НЕ Отказ Тогда
		ОбработатьШтрихкодыНаСервере(ДанныеШтрихкодов, КэшированныеЗначения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект, "Характеристика", "ХарактеристикиИспользуются");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.Code128")
	 ИЛИ Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.SSCC")
	 ИЛИ Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_128")
	 ИЛИ Объект.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.GS1_DataBarExpandedStacked") Тогда
		Элементы.СгенерироватьШтрихкод.Видимость = Истина;
	Иначе
		Элементы.СгенерироватьШтрихкод.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар") Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОсновное;
	Иначе
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
	ДоступноИзменение = ПустаяСтрока(Объект.ХешСумма);
	
	Элементы.ВложенныеШтрихкоды.ТолькоПросмотр = НЕ ДоступноИзменение;
	Элементы.ГруппаШтрихкод.ТолькоПросмотр     = НЕ ДоступноИзменение;
	Элементы.ВложенныеШтрихкодыПоискПоШтрихкоду.Доступность = ДоступноИзменение;
	Элементы.СгенерироватьШтрихкод.Доступность = ДоступноИзменение;
	
	Элементы.Упаковка.Доступность = ЗначениеЗаполнено(Объект.Номенклатура);
	
	Если Форма.ХарактеристикиИспользуются Тогда
		Элементы.Характеристика.Доступность = Истина;
		Элементы.Характеристика.ПодсказкаВвода = "";
	Иначе
		Элементы.Характеристика.Доступность = Ложь;
		Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<характеристики не используются>'");
	КонецЕсли;
	
	Если Форма.СерииИспользуются Тогда
		Элементы.Серия.Доступность = Истина;
		Элементы.Серия.ПодсказкаВвода = "";
	Иначе
		Элементы.Серия.Доступность = Ложь;
		Элементы.Серия.ПодсказкаВвода = НСтр("ru = '<серии не используются>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	ХарактеристикиИспользуются = ПризнакИспользованияХарактеристик(Объект.Номенклатура);
	СерииИспользуются = ПризнакИспользованияСерий(Объект.Номенклатура);
	ПараметрыУказанияСерий = ГосударственныеИнформационныеСистемыПереопределяемый.ПараметрыУказанияСерийФормыОбъекта(Объект, Справочники.ШтрихкодыУпаковокТоваров);
	СобытияФормЕГАИСПереопределяемый.УстановитьИнформациюОЕдиницеХранения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПризнакИспользованияХарактеристик(Номенклатура)
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ПризнакИспользованияХарактеристик(Номенклатура);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПризнакИспользованияСерий(Номенклатура)
	
	Возврат ГосударственныеИнформационныеСистемыПереопределяемый.ПризнакИспользованияСерий(Номенклатура);
	
КонецФункции

&НаКлиенте
Процедура ОбработкаГенерацииШтрихкода(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ Результат = Неопределено Тогда
		Объект.ЗначениеШтрихкода = Результат.Штрихкод;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВложенныеШтрихкодыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ВложенныеШтрихкоды.ТолькоПросмотр Тогда
		
		ТекущиеДанные = Объект.ВложенныеШтрихкоды.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Штрихкод);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
