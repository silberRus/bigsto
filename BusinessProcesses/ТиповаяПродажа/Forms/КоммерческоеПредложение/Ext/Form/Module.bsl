﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма, Объект, Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);

	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КоммерческоеПредложениеКлиенту.Ссылка
		|ИЗ
		|	Документ.КоммерческоеПредложениеКлиенту КАК КоммерческоеПредложениеКлиенту
		|ГДЕ
		|	НЕ КоммерческоеПредложениеКлиенту.ПометкаУдаления
		|	И КоммерческоеПредложениеКлиенту.Сделка = &Сделка
		|	И КоммерческоеПредложениеКлиенту.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыКоммерческихПредложенийКлиентам.Отменено)");
		
	Запрос.УстановитьПараметр("Сделка", Задание.Предмет);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	КоличествоДействующихПредолжений = Выборка.Количество();
	
	Если КоличествоДействующихПредолжений = 1 Тогда
		Выборка.Следующий();
		КоммерческоеПредложение = Выборка.Ссылка;
		Элементы.КП.Заголовок   = КоммерческоеПредложение;
	ИначеЕсли КоличествоДействующихПредолжений > 1 Тогда
		Элементы.КП.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Коммерческих предложений - %1'"),
		                                                                                КоличествоДействующихПредолжений) ;
	Иначе
		Элементы.КП.Заголовок = НСтр("ru='Создать коммерческое предложение'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Перем ПараметрСделка;
	
	Если ИмяСобытия = "Запись_КоммерческоеПредложениеКлиенту"
		И Параметр.Свойство("Сделка", ПараметрСделка) Тогда
		
		Если ПараметрСделка = Задание.Предмет Тогда
			КоммерческоеПредложение                               = Источник;
			Элементы.КП.Заголовок   = Источник;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма,Истина,Новый Структура("Сделка",Объект.Предмет));

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияКоммерческоеПредложениеНажатие(Элемент)
	
	Если ЗначениеЗаполнено(КоммерческоеПредложение) Тогда
		ПоказатьЗначение(Неопределено, КоммерческоеПредложение);
	ИначеЕсли СтрНайти(Элементы.КП.Заголовок,НСтр("ru = 'Создать'")) > 0  Тогда
		ОткрытьФорму(
			"Документ.КоммерческоеПредложениеКлиенту.ФормаОбъекта",
			Новый Структура("Основание", Задание.Предмет),,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		
		СтруктураОтбор = Новый Структура("Сделка", Задание.Предмет);
		ПараметрыФормы = Новый Структура("Отбор", СтруктураОтбор);
		
		ОткрытьФорму(
			"Документ.КоммерческоеПредложениеКлиенту.Форма.ФормаСписка",
			ПараметрыФормы,,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
