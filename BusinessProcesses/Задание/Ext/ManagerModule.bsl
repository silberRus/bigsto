﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("Исполнитель");
	Результат.Добавить("ПроверитьВыполнение");
	Результат.Добавить("Проверяющий");
	Результат.Добавить("СрокИсполнения");
	Результат.Добавить("СрокПроверки");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи

// Получить структуру с описанием формы выполнения задачи.
// Вызывается при открытии формы выполнения задачи.
//
// Параметры:
//   ЗадачаСсылка                - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
// Возвращаемое значение:
//   Структура   - структуру с описанием формы выполнения задачи.
//                 Ключ "ИмяФормы" содержит имя формы, передаваемое в метод контекста ОткрытьФорму(). 
//                 Ключ "ПараметрыФормы" содержит параметры формы. 
//
Функция ФормаВыполненияЗадачи(ЗадачаСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПараметрыФормы", Новый Структура("Ключ", ЗадачаСсылка));
	Результат.Вставить("ИмяФормы", "БизнесПроцесс.Задание.Форма.Действие" + ТочкаМаршрутаБизнесПроцесса.Имя);
	Возврат Результат;
	
КонецФункции

// Вызывается при перенаправлении задачи.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - перенаправляемая задача.
//   НоваяЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача для нового исполнителя.
//
Процедура ПриПеренаправленииЗадачи(ЗадачаСсылка, НоваяЗадачаСсылка) Экспорт
	
	БизнесПроцессОбъект = ЗадачаСсылка.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(БизнесПроцессОбъект.Ссылка);
	БизнесПроцессОбъект.РезультатВыполнения = РезультатВыполненияПриПеренаправлении(ЗадачаСсылка) 
		+ БизнесПроцессОбъект.РезультатВыполнения;
	УстановитьПривилегированныйРежим(Истина);
	БизнесПроцессОбъект.Записать();
	
КонецПроцедуры

// Вызывается при выполнении задачи из формы списка.
//
// Параметры:
//   ЗадачаСсылка  - ЗадачаСсылка.ЗадачаИсполнителя - задача.
//   БизнесПроцессСсылка - БизнесПроцессСсылка - бизнес-процесс, по которому сформирована задача ЗадачаСсылка.
//   ТочкаМаршрутаБизнесПроцесса - ТочкаМаршрутаБизнесПроцессаСсылка - точка маршрута.
//
Процедура ОбработкаВыполненияПоУмолчанию(ЗадачаСсылка, БизнесПроцессСсылка, ТочкаМаршрутаБизнесПроцесса) Экспорт
	
	// Устанавливаем значения по умолчанию для пакетного выполнения задач.
	Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаданиеОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
		ЗаданиеОбъект.Выполнено = Истина;	
		ЗаданиеОбъект.Записать();
	ИначеЕсли ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Задание.ТочкиМаршрута.Проверить Тогда
		УстановитьПривилегированныйРежим(Истина);
		ЗаданиеОбъект = БизнесПроцессСсылка.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
		ЗаданиеОбъект.Выполнено = Истина;
		ЗаданиеОбъект.Подтверждено = Истина;
		ЗаданиеОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры	

// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// которые необходимо обновить на новую версию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаСНаборамиЗначенийДоступа.Ссылка
		|ИЗ
		|	%1 КАК ТаблицаСНаборамиЗначенийДоступа
		|УПОРЯДОЧИТЬ ПО
		|	ТаблицаСНаборамиЗначенийДоступа.Дата УБЫВ";
	
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Запрос.Текст, Метаданные.БизнесПроцессы.Задание.ПолноеИмя());
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	БизнесПроцесс = Метаданные.БизнесПроцессы.Задание;
	ИмяПроцедуры = "БизнесПроцессы.Задание.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Задание = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "БизнесПроцесс.Задание");
	
	Пока Задание.Следующий() Цикл
		Попытка
			ОбновитьНаборыЗначенийДоступаЗадания(Параметры, Задание.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
		Исключение
			// Если не удалось обработать задание, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обновить права доступа для ""%1"" в обработчике ""%2"" по причине:
					|%3'"), 
					Задание.Ссылка, ИмяПроцедуры, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				БизнесПроцесс, Задание.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "БизнесПроцесс.Задание");
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ""%1"" не удалось обновить права доступа для некоторых объектов (пропущены): %2'"),
				ИмяПроцедуры, ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
	БизнесПроцесс,, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ""%1"" обновила права доступа для очередной порции объектов: %2'"), 
		ИмяПроцедуры, ОбъектовОбработано));
	
КонецПроцедуры

Процедура ОбновитьНаборыЗначенийДоступаЗадания(Параметры, ЗаданиеСсылка) 
	
	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
	НачатьТранзакцию();
	
	Попытка
		// Блокируем объект от изменения другими сеансами.
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("БизнесПроцесс.Задание");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ЗаданиеСсылка);
		Блокировка.Заблокировать();
		
		ЗаданиеОбъект = ЗаданиеСсылка.ПолучитьОбъект();
		Если ЗаданиеОбъект = Неопределено
			Или ЗаданиеОбъект.ГруппаИсполнителейЗадач <> Справочники.ГруппыИсполнителейЗадач.ПустаяСсылка() Тогда
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЗаданиеСсылка);
			Возврат;
		КонецЕсли;
		
		ЗаданиеОбъект.ГруппаИсполнителейЗадач = ?(ТипЗнч(ЗаданиеОбъект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей"), 
			БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(ЗаданиеОбъект.Исполнитель, 
			ЗаданиеОбъект.ОсновнойОбъектАдресации, ЗаданиеОбъект.ДополнительныйОбъектАдресации), 
			ЗаданиеОбъект.Исполнитель);
		ЗаданиеОбъект.ГруппаИсполнителейЗадачПроверяющий = ?(ТипЗнч(ЗаданиеОбъект.Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей"), 
			БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(ЗаданиеОбъект.Проверяющий, 
				ЗаданиеОбъект.ОсновнойОбъектАдресацииПроверяющий, ЗаданиеОбъект.ДополнительныйОбъектАдресацииПроверяющий), 
			ЗаданиеОбъект.Проверяющий);
		
		МодульУправлениеДоступом.ОбновитьНаборыЗначенийДоступа(ЗаданиеОбъект);
		Если ЗаданиеОбъект.Модифицированность() Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЗаданиеОбъект);
		Иначе
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЗаданиеСсылка);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие

// Устанавливает состояние элементов формы задачи.
Процедура УстановитьСостояниеЭлементовФормыЗадачи(Форма) Экспорт
	
	Если Форма.Элементы.Найти("РезультатВыполнения") <> Неопределено 
		И Форма.Элементы.Найти("ИсторияВыполнения") <> Неопределено Тогда
			Форма.Элементы.ИсторияВыполнения.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Форма.ЗаданиеРезультатВыполнения);
	КонецЕсли;
	
	Форма.Элементы.Предмет.Гиперссылка = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
	Форма.ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Форма.Объект.Предмет);	
	
КонецПроцедуры	

Функция РезультатВыполненияПриПеренаправлении(Знач ЗадачаСсылка)
	
	СтрокаФормат = "%1, %2 " + НСтр("ru = 'перенаправил(а) задачу'") + ":
		|%3
		|";
	
	Комментарий = СокрЛП(ЗадачаСсылка.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаСсылка.ДатаИсполнения, ЗадачаСсылка.Исполнитель, Комментарий);
	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли