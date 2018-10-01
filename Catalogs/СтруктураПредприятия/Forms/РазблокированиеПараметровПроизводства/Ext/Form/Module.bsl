﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		
		Элементы.ПроизводствоБезЗаказаЗаголовок.Заголовок = НСтр("ru = 'Производство'");
		
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовЗаголовок.Заголовок =
			НСтр("ru = 'Вариант списания затрат на выпуск'");
		
	КонецЕсли;
	
	ЗаполнитьПроверяемыеПараметры();
	
	УправлениеВидимостью();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Результат = БлокируемыеРеквизитыОбъекта();
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИспользованиеОбъекта(Команда)
	
	Результат = ПроверитьИспользованиеОбъектаНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1.2; // Уменьшим шаг увеличения времени опроса выполнения задания
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	Иначе
		ПолучитьРезультатПроверкиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

// Унифицированная процедура проверки выполнения фонового задания.
//
&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ПолучитьРезультатПроверкиНаСервере();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьИспользованиеОбъектаНаСервере()
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Объект", Параметры.Объект);
	
	Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьРезультатПроверкиНаСервере()
	
	РезультатПроверки = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ОбъектИспользуется = Ложь;
	
	
	// Производство без заказов
	Если ПроверятьПроизводствоБезЗаказа Тогда
		
		Элементы.ПроизводствоБезЗаказаПроверкаНеВыполнена.Видимость = Ложь;
		
		Элементы.ПроизводствоБезЗаказаПараметрНеИспользуется.Видимость =
			НЕ РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ПроизводствоБезЗаказаПараметрИспользуется.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ПроизводствоБезЗаказаПараметрИспользуетсяОписание.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Вариант списания затрат на выпуски без заказов
	Если ПроверятьВариантСписанияЗатратНаВыпускиБезЗаказов Тогда
		
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПроверкаНеВыполнена.Видимость = Ложь;
		
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПараметрНеИспользуется.Видимость =
			НЕ РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПараметрИспользуется.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		Элементы.ВариантСписанияЗатратНаВыпускиБезЗаказовПараметрИспользуетсяОписание.Видимость =
			РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов;
			
		ОбъектИспользуется = ?(РезультатПроверки.ИспользуетсяДляПроизводстваБезЗаказов, Истина, ОбъектИспользуется);
		
	КонецЕсли;
	
	// Результат проверки
	Если ОбъектИспользуется Тогда
		Элементы.ГруппаОбъектИспользуетсяСтраницы.ТекущаяСтраница = Элементы.ГруппаОбъектИспользуетсяОбъектИспользуется;
	Иначе
		Элементы.ГруппаОбъектИспользуетсяСтраницы.ТекущаяСтраница = Элементы.ГруппаОбъектИспользуетсяОбъектНеИспользуется;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция БлокируемыеРеквизитыОбъекта()
	
	Реквизиты = Справочники.СтруктураПредприятия.ПолучитьБлокируемыеРеквизитыОбъекта();
	
	Индекс = 0;
	Для каждого Реквизит Из Реквизиты Цикл
		
		СимволРазделитель = СтрНайти(Реквизит, ";");
		Если НЕ СимволРазделитель = 0 Тогда
			Реквизиты[Индекс] = СокрЛП(Лев(Реквизит, СимволРазделитель-1));
		КонецЕсли;
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Возврат Реквизиты;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПроверяемыеПараметры()
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	ПроверятьПодразделениеДиспетчер = Не ЭтоКА;
	ПроверятьПроизводствоПоЗаказу = Не ЭтоКА;
	ПроверятьИнтервалПланирования = Не ЭтоКА;
	
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостью()
	
	Элементы.ГруппаПодразделениеДиспетчер.Видимость = ПроверятьПодразделениеДиспетчер;
	Элементы.ГруппаПроизводствоПоЗаказу.Видимость = ПроверятьПроизводствоПоЗаказу;
	Элементы.ГруппаИнтервалПланирования.Видимость = ПроверятьИнтервалПланирования;
	Элементы.ГруппаУправлениеМаршрутнымиЛистами.Видимость = ПроверятьУправлениеМаршрутнымиЛистами;
	Элементы.ГруппаСпособУправленияОперациями.Видимость = ПроверятьСпособУправленияОперациями;
	Элементы.ГруппаПроизводствоБезЗаказа.Видимость = ПроверятьПроизводствоБезЗаказа;
	Элементы.ГруппаВариантСписанияЗатратНаВыпускиБезЗаказов.Видимость = ПроверятьВариантСписанияЗатратНаВыпускиБезЗаказов;
	Элементы.ГруппаПооперационноеУправлениеЭтапами.Видимость = ПроверятьПооперационноеУправлениеЭтапами;
	
КонецПроцедуры

#КонецОбласти
