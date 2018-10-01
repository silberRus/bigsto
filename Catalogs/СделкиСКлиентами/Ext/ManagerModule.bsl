﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Добавляет команду создания объекта.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Справочники.СделкиСКлиентами) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Справочники.СделкиСКлиентами.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Справочники.СделкиСКлиентами);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьСделкиСКлиентами";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

//Используеся в механизме взаимодействий. Возвращает клиента и участников сделки
//
//
// Параметры:
//  Ссылка  - СправочникСсылка.СделкиСКлиентами - сделка, по которой получаются контакты
//
// Возвращаемое значение:
//   Массив   - массив, содержащий контакты
//
Функция ПолучитьКонтакты(Ссылка) Экспорт

	Возврат СделкиСервер.ПолучитьУчастниковПоТабличнойЧастиПредметаВзаимодействия(
		Ссылка, ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,"Партнер"));

КонецФункции

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Наименование");
	Результат.Добавить("Код");
	Результат.Добавить("ВалютаПервичногоСпроса");
	Результат.Добавить("ДатаНачала");
	Результат.Добавить("ДатаОкончания");
	Результат.Добавить("Комментарий");
	Результат.Добавить("ОбособленныйУчетТоваровПоСделке");
	Результат.Добавить("Ответственный");
	Результат.Добавить("ПотенциальнаяСуммаПродажи");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Справочник.СделкиСКлиентами.Форма.ФормаСписка";
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Справочники.СделкиСКлиентами))
		И ПравоДоступа("Изменение", Метаданные.Справочники.СделкиСКлиентами)
		И ПолучитьФункциональнуюОпцию("ИспользоватьСделкиСКлиентами");
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СделкиСКлиентами.Ссылка) КАК СделкиСКлиентамиВсегоВРаботе
	|ИЗ
	|	Справочник.СделкиСКлиентами КАК СделкиСКлиентами
	|ГДЕ
	|	СделкиСКлиентами.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыСделок.ВРаботе)
	|	И СделкиСКлиентами.Ответственный = &Пользователь
	|	И (НЕ СделкиСКлиентами.ПометкаУдаления)
	|	И (НЕ СделкиСКлиентами.Закрыта)";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// СделкиСКлиентами
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "СделкиСКлиентами";
	ДелоРодитель.ЕстьДела       = Результат.СделкиСКлиентамиВсегоВРаботе > 0;
	ДелоРодитель.Представление  = НСтр("ru = 'Сделки с клиентами'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Продажи;
	
	// СделкиСКлиентамиВсегоВРаботе
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Статус", "ВРаботе");
	ПараметрыОтбора.Вставить("ТолькоКлиент", Истина);
	ПараметрыОтбора.Вставить("Ответственный", ОбщиеПараметрыЗапросов.Пользователь);
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "СделкиСКлиентамиВсегоВРаботе";
	Дело.ЕстьДела       = Результат.СделкиСКлиентамиВсегоВРаботе > 0;
	Дело.Представление  = НСтр("ru = 'Всего сделок в работе'");
	Дело.Количество     = Результат.СделкиСКлиентамиВсегоВРаботе;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "СделкиСКлиентами";
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Если ПравоДоступа("Чтение", Метаданные.Документы.ЗаказКлиента)
		И ПравоДоступа("Чтение", Метаданные.Документы.КоммерческоеПредложениеКлиенту)
		И ПравоДоступа("Чтение", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
		КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуАнализЦенПоставщиковПоДокументу(КомандыОтчетов);
		Если КомандаОтчет <> Неопределено Тогда
		КонецЕсли;
		
	КонецЕсли;
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСоставПродажи(КомандыОтчетов);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


