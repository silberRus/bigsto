﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Почта.
	Если Не ИнтеграцияС1СДокументооборотПовтИсп.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
		Элементы.ФормаСоздатьПисьмо.Видимость = Ложь;
		Элементы.ФормаСоздатьПроцесс.Видимость = Ложь;
	КонецЕсли;
	
	ДоступенЗахватИРедактирование = ИнтеграцияС1СДокументооборотПовтИсп.
		ДоступенФункционалВерсииСервиса("1.4.9.1");
	Элементы.ОткрытьДляРедактирования.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ПанельОткрытьДляРедактирования.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ЗакончитьРедактирование.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ПанельЗакончитьРедактирование.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ПанельСохранитьИзменения.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ПанельОтменитьРедактирование.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ПанельОткрытьКаталогФайла.Видимость = ДоступенЗахватИРедактирование;
	
	Элементы.ПредставлениеРедактирует.Видимость = ДоступенЗахватИРедактирование;
	Элементы.ДекорацияРедактируется.Видимость = Не ДоступенЗахватИРедактирование;
	
	КаталогДляСохраненияДанных = ИнтеграцияС1СДокументооборотВызовСервера.ЛокальныйКаталогФайлов();
	
	Параметры.Свойство("ID", ID);
	Параметры.Свойство("ОригиналID", ОригиналID);
	
	Если Не Параметры.Свойство("РазрешеноРедактирование", РазрешеноРедактирование) Тогда
		РазрешеноРедактирование = Истина;
	КонецЕсли;
	
	ПолучитьОписаниеФайлаИЗаполнитьФорму();
	
	НастройкиДокументооборота = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьНастройки();
	ИспользоватьЭПвДО  = НастройкиДокументооборота.ИспользоватьЭлектронныеЦифровыеПодписи;
	ИспользоватьЭП = ИнтеграцияС1СДокументооборотВызовСервера.ИспользоватьЭлектронныеЦифровыеПодписи();
	
	Если ИспользоватьЭПвДО = Ложь Тогда
		Элементы.ГруппаЭП.Видимость = Ложь;
		Элементы.ФормаСохранитьВместеСЭП.Видимость = Ложь;
	КонецЕсли;
	
	Если ИспользоватьЭПвДО = Ложь 
		Или ИспользоватьЭП = Ложь Тогда
		Элементы.ФормаПодписать.Видимость = Ложь;
		Элементы.ФормаДобавитьЭПИзФайла.Видимость = Ложь;
		Элементы.ТаблицаПодписейПроверить.Видимость = Ложь;
		Элементы.ТаблицаПодписейПроверитьВсе.Видимость = Ложь;
	КонецЕсли;
	
	КолонкиМассив = Новый Массив;
	Для Каждого ОписаниеКолонки Из РеквизитФормыВЗначение("ТаблицаПодписей").Колонки Цикл
		КолонкиМассив.Добавить(ОписаниеКолонки.Имя);
	КонецЦикла;
	ОписаниеКолонокТаблицыПодписей = Новый ФиксированныйМассив(КолонкиМассив);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотФайл" Тогда
		Если Источник = ID Тогда
			ПолучитьОписаниеФайлаИЗаполнитьФорму();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьКомандСпискаЭП();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗакрытиеСПараметром Тогда 
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
		ТекстПредупреждения = "";
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы,,ТекстПредупреждения);
		
	Иначе
		
		Отказ = Истина;
		ПодключитьОбработчикОжидания("ЗакрытьСПараметром", 0.1, Истина);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСвойства

&НаКлиенте
Процедура СвойстваЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыбратьЗначениеДополнительногоРеквизита(
		ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Свойства.ТекущиеДанные;
	Если ТекущиеДанные.СписокДоступныхТипов.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
		
	Если ТипЗнч(ТекущиеДанные.Значение) = Тип("Строка") Тогда
		ТипXDTO =ТекущиеДанные.СписокДоступныхТипов[0].Значение.xdtoClassName;
		Если ТипXDTO = "integer" Тогда
			ТекущиеДанные.Значение = 0;
		ИначеЕсли ТипXDTO = "boolean" Тогда
			ТекущиеДанные.Значение = Ложь;
		ИначеЕсли ТипXDTO = "date" Тогда
			ТекущиеДанные.Значение = Дата(1, 1, 1);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СвойстваЗначениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Свойства.ТекущиеДанные;
	Если ТекущиеДанные.СписокДоступныхТипов.Количество() <> 1 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
		
	ТипXDTO = ТекущиеДанные.СписокДоступныхТипов[0].Значение.xdtoClassName;
	
	Если ТипXDTO = "integer"
		Или ТипXDTO = "boolean"
		Или ТипXDTO = "date"
		Или ТипXDTO = "string" Тогда
		Возврат;
	КонецЕсли;
		
	Если ТипXDTO = "DMObjectPropertyValue" Тогда
		ДополнительноеСвойство = Новый Структура;
		ДополнительноеСвойство.Вставить("id", ТекущиеДанные.СвойствоID);
		ДополнительноеСвойство.Вставить("type", ТекущиеДанные.СвойствоТип);
		Отбор = Новый Структура("additionalProperty", ДополнительноеСвойство);
	Иначе
		Отбор = Неопределено;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
		ТипXDTO, ДанныеВыбора, Текст, СтандартнаяОбработка, Отбор);
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваЗначениеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Свойства.ТекущиеДанные;
	Если ТекущиеДанные.СписокДоступныхТипов.Количество() <> 1 Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
		
	ТипXDTO = ТекущиеДанные.СписокДоступныхТипов[0].Значение.xdtoClassName;
	
	Если ТипXDTO = "integer" 
		Или ТипXDTO = "boolean" 
		Или ТипXDTO = "string" 
		Или ТипXDTO = "date" Тогда
		Возврат;
	КонецЕсли;
		
	Если ТипXDTO = "DMObjectPropertyValue" Тогда
		ДополнительноеСвойство = Новый Структура;
		ДополнительноеСвойство.Вставить("id", ТекущиеДанные.СвойствоID);
		ДополнительноеСвойство.Вставить("type", ТекущиеДанные.СвойствоТип);
		Отбор = Новый Структура("additionalProperty", ДополнительноеСвойство);
	Иначе
		Отбор = Неопределено;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотВызовСервера.ДанныеДляАвтоПодбора(
		ТипXDTO, ДанныеВыбора, Текст, СтандартнаяОбработка, Отбор);
	
	Если ДанныеВыбора.Количество() = 1 Тогда 
		ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
			"Значение", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
		СтандартнаяОбработка = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СвойстваЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора(
		"Значение", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма, Истина, Элемент);
		
КонецПроцедуры

&НаКлиенте
Процедура СвойстваЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элементы.Свойства.ТекущиеДанные.Значение = "";
	Элементы.Свойства.ТекущиеДанные.ЗначениеID = "";
	Элементы.Свойства.ТекущиеДанные.ЗначениеТип = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЭП

&НаКлиенте
Процедура ТаблицаПодписейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектроннаяПодписьКлиент.ОткрытьПодпись(Элементы.ТаблицаПодписей.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПодпись(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УдалитьЗавершение", ЭтаФорма);
	ТекстВопроса = НСтр("ru = 'Удалить выделенные подписи?'");
	ИнтеграцияС1СДокументооборотКлиент.ПоказатьВопросДаНет(Оповещение, ТекстВопроса,
		НСтр("ru='Удалить'"), НСтр("ru='Не удалять'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Отказ = Ложь;
	ЗаписатьВыполнитьКлиент(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВСписке(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайла);
	ПараметрыФормы.Вставить("ТекущийФайл", ID);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ПрисоединенныеФайлы",
		ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаЧтение(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьФайл(ID, Наименование, Расширение,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляРедактирования(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение",
		ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьФайл(ID, Наименование, Расширение,
		УникальныйИдентификатор, Ложь, ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение",
		ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.ЗакончитьРедактированиеФайла(ID, Наименование, Расширение,
		УникальныйИдентификатор, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаДиск(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.СохранитьФайлКак(ID, Наименование, Расширение, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайловыеОперацииЕще(Команда)
	
	Подменю = Новый СписокЗначений;
	Если ДоступенЗахватИРедактирование Тогда
		Подменю.Добавить("ОткрытьКаталогФайла", НСтр("ru = 'Открыть каталог файла'"),, 
			БиблиотекаКартинок.Папка);
	КонецЕсли;
	Если (Не Редактируется Или РедактируетсяТекущимПользователем)
		И РазрешеноРедактирование Тогда
		Подменю.Добавить("ОбновитьИзФайлаНаДиске", НСтр("ru = 'Обновить из файла на диске'"),, 
			БиблиотекаКартинок.ОбновитьФайлИзФайлаНаДиске);
	КонецЕсли;
	Если ДоступенЗахватИРедактирование И РедактируетсяТекущимПользователем Тогда
		Подменю.Добавить("ОтменитьРедактирование", НСтр("ru = 'Отменить редактирование'"),,
			БиблиотекаКартинок.ОсвободитьФайл);
		Если РазрешеноРедактирование Тогда
			Подменю.Добавить("СохранитьИзменения", НСтр("ru = 'Сохранить изменения'"),,
				БиблиотекаКартинок.ОпубликоватьФайл);
		КонецЕсли;
	КонецЕсли;
	ОписаниеОповещения = Новый ОписаниеОповещения("ФайловыеОперацииЕщеПослеВыбора", ЭтаФорма);
	ПоказатьВыборИзМеню(ОписаниеОповещения, Подменю, Элементы.ФайловыеОперацииЕще);
	
КонецПроцедуры

&НаКлиенте
Процедура ФайловыеОперацииЕщеПослеВыбора(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Значение = "ОткрытьКаталогФайла" Тогда
		ОткрытьКаталогФайла();
	ИначеЕсли Результат.Значение = "ОбновитьИзФайлаНаДиске" Тогда
		ОбновитьИзФайлаНаДиске();
	ИначеЕсли Результат.Значение = "ОтменитьРедактирование" Тогда
		ОтменитьРедактирование();
	ИначеЕсли Результат.Значение = "СохранитьИзменения" Тогда
		СохранитьИзменения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла()
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьКаталогФайла(ID);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.ОбновитьИзФайлаНаДиске(ID, Наименование, Расширение,
		УникальныйИдентификатор, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактирование()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.ОтменитьРедактированиеФайла(ID, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандыРедактированияЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.СохранитьИзмененияРедактируемогоФайла(ID,
		Наименование, Расширение, УникальныйИдентификатор, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	ДанныеПодписейФайла = ИнтеграцияС1СДокументооборотКлиент.ДанныеПодписейФайла(ID, ТаблицаПодписей);
	
	ИнтеграцияС1СДокументооборотКлиент.ПодписатьФайл(
		ID, Наименование, Редактируется, Зашифрован, Описание, ДанныеПодписейФайла);
		
	УстановитьДоступностьКомандСпискаЭП();

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	ПараметрыФормы = Новый Структура("ГлавнаяЗадача, Предмет", Новый Структура, Новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", Наименование);
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.СозданиеБизнесПроцесса", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПисьмо(Команда)
	
	ПараметрыФормы = Новый Структура("Предмет", Новый Структура);
	
	ПараметрыФормы.Предмет.Вставить("name", Наименование);
	ПараметрыФормы.Предмет.Вставить("id", ID);
	ПараметрыФормы.Предмет.Вставить("type", Тип);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭПИзФайла(Команда)
	
	ДанныеПодписейФайла = ИнтеграцияС1СДокументооборотКлиент.ДанныеПодписейФайла(ID, ТаблицаПодписей);
	
	Оповещение = Новый ОписаниеОповещения("ДобавитьЭПИзФайлаЗавершение", ЭтаФорма);
	
	СвойстваФайла = Новый Структура;
	СвойстваФайла.Вставить("ИмяФайла", Наименование);
	СвойстваФайла.Вставить("ИдентификаторФайла", ID);
	СвойстваФайла.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	СвойстваФайла.Вставить("ОписаниеФайла", Описание);
	СвойстваФайла.Вставить("ДанныеПодписейФайла", ДанныеПодписейФайла);
	
	ИнтеграцияС1СДокументооборотКлиент.НачатьДобавлениеЭПИзФайла(Оповещение, СвойстваФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭПИзФайлаЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	УстановитьДоступностьКомандСпискаЭП();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭП(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.НачатьСохранениеВместеСЭП(ID, Расширение, Наименование, 
		Размер, ДатаМодификацииУниверсальная, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	НастройкиЭП = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки();
	
	Если НастройкиЭП.ВыполнятьПроверкуЭПНаСервере
		И Не Зашифрован Тогда
		
		ДанныеВыделенныхСтрок = Новый Массив;
		ИменаКолонок = "";
		Для Каждого ИмяКолонки Из ОписаниеКолонокТаблицыПодписей Цикл
			ИменаКолонок = ИменаКолонок + ИмяКолонки + ",";
		КонецЦикла;
		ИменаКолонок = Лев(ИменаКолонок, СтрДлина(ИменаКолонок)-1);
		
		Для Каждого Элемент Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
			ДанныеСтроки = Новый Структура(ИменаКолонок);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ТаблицаПодписей.НайтиПоИдентификатору(Элемент));
			ДанныеВыделенныхСтрок.Добавить(ДанныеСтроки);
		КонецЦикла;
		
		ПроверитьНаСервере(ДанныеВыделенныхСтрок);
		
		Индекс = 0;
		Для Каждого Элемент Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
			Строка = ТаблицаПодписей.НайтиПоИдентификатору(Элемент);
			Строка.Статус = ДанныеВыделенныхСтрок[Индекс].Статус;
			Строка.Неверна = ДанныеВыделенныхСтрок[Индекс].Неверна;
			Индекс = Индекс + 1;
		КонецЦикла;
		
	Иначе // проверка подписей на клиенте
		
		АдресФайла = ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьФайлИПоместитьВХранилище(
			ID, УникальныйИдентификатор);
		ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодписи(Элементы.ТаблицаПодписей.ВыделенныеСтроки,
			ТаблицаПодписей, УникальныйИдентификатор, АдресФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВсе(Команда)
	
	НастройкиЭП = ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки();
	
	Если НастройкиЭП.ВыполнятьПроверкуЭПНаСервере 
		И Не Зашифрован Тогда
		
		ДанныеСтрок = Новый Массив;
		ИменаКолонок = "";
		Для Каждого ИмяКолонки Из ОписаниеКолонокТаблицыПодписей Цикл
			ИменаКолонок = ИменаКолонок + ИмяКолонки + ",";
		КонецЦикла;
		ИменаКолонок = Лев(ИменаКолонок, СтрДлина(ИменаКолонок)-1);
		
		Для Каждого СтрокаТЗ Из ТаблицаПодписей Цикл
			ДанныеСтроки = Новый Структура(ИменаКолонок);
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаТЗ);
			ДанныеСтрок.Добавить(ДанныеСтроки);
		КонецЦикла;
		
		ПроверитьВсеНаСервере(ДанныеСтрок);
		
		Индекс = 0;
		Для Каждого СтрокаТЗ Из ТаблицаПодписей Цикл
			СтрокаТЗ.Статус = ДанныеСтрок[Индекс].Статус;
			СтрокаТЗ.Неверна = ДанныеСтрок[Индекс].Неверна;
			Индекс = Индекс + 1;
		КонецЦикла;
		
	Иначе // проверка на клиенте
		
		АдресФайла = ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьФайлИПоместитьВХранилище(
			ID, УникальныйИдентификатор);
		ВсеПодписи = Новый Массив;
		Для Каждого СтрокаПодписи из ТаблицаПодписей Цикл
			ВсеПодписи.Добавить(СтрокаПодписи.ПолучитьИдентификатор());
		КонецЦикла;
		ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодписи(ВсеПодписи, ТаблицаПодписей, 
			УникальныйИдентификатор, АдресФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодпись(Команда)
	
	ЭлектроннаяПодписьКлиент.ОткрытьПодпись(Элементы.ТаблицаПодписей.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Отказ = Ложь;
	ЗаписатьВыполнитьКлиент(Отказ);
	
КонецПроцедуры

 &НаКлиенте
Процедура Сохранить(Команда)
	
	Если Элементы.ТаблицаПодписей.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Элементы.ТаблицаПодписей.ТекущиеДанные.Объект) Тогда
		ЭлектроннаяПодписьКлиент.СохранитьПодпись(Элементы.ТаблицаПодписей.ТекущиеДанные.АдресПодписи);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывается после запроса "Сохранить изменения" и завершает закрытие.
//
&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ПараметрыОповещения) Экспорт
	
	Отказ = Ложь;
	
	ЗаписатьВыполнитьКлиент(Отказ);
	ПараметрыОповещения = Новый Структура;
	Оповестить("Запись_ДокументооборотДокумент", ПараметрыОповещения, ЭтаФорма.ВладелецФормы);
	
	Если Не Отказ Тогда
		ЗакрытьСПараметром();
	КонецЕсли; 
	
КонецПроцедуры

// Закрывает форму без вопросов и проверки модифицированности.
//
&НаКлиенте
Процедура ЗакрытьСПараметром()
	
	ЗакрытиеСПараметром = Истина;
	Закрыть(КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

// Заполняет форму данными файла.
//
&НаСервере
Процедура ЗаполнитьФорму(ОписаниеФайла)
	
	Размер = ОписаниеФайла.Размер;
	ПредставлениеРазмера = ИнтеграцияС1СДокументооборотКлиентСервер.КраткоеПредставлениеРазмера(Размер);
	Наименование = ОписаниеФайла.Наименование;
	Описание = ОписаниеФайла.Описание;
	Расширение = ОписаниеФайла.Расширение;
	ПолноеИмяФайла = ИнтеграцияС1СДокументооборотКлиентСервер.ИмяСРасширением(Наименование, Расширение);
	ДатаСоздания = ОписаниеФайла.ДатаСоздания;
	ДатаМодификацииУниверсальная = ОписаниеФайла.ДатаМодификацииУниверсальная;
	Автор = ОписаниеФайла.Автор;
	Тип = "DMFile";
	Зашифрован = ОписаниеФайла.Зашифрован;
	Редактируется = ОписаниеФайла.Редактируется;
	
	ИндексКартинки = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
	
	Если ОписаниеФайла.Свойство("Владелец") и ЗначениеЗаполнено(ОписаниеФайла.Владелец) Тогда
		ПредставлениеВладельца = ОписаниеФайла.Владелец;
		Элементы.ПредставлениеВладельца.Видимость = Истина;
		ОписаниеФайла.Свойство("Владелец", Владелец);
		ОписаниеФайла.Свойство("ВладелецID", ВладелецID);
		ОписаниеФайла.Свойство("ВладелецТип", ВладелецТип);
		ОписаниеФайла.Свойство("ВладелецФайла", ВладелецФайла);
		Элементы.ФормаПоказатьВСписке.Видимость = Истина;
	Иначе
		Элементы.ПредставлениеВладельца.Видимость = Ложь;
		Элементы.ФормаПоказатьВСписке.Видимость = Ложь;
	КонецЕсли;
	
	ПредставлениеСоздан = Формат(ОписаниеФайла.ДатаСоздания, "ДФ='dd.MM.yyyy HH:mm'") 
		+ " (" + ОписаниеФайла.Автор +  ")";
	ПредставлениеИзменен = Формат(ОписаниеФайла.ДатаМодификации, "ДФ='dd.MM.yyyy HH:mm'");
	Если ОписаниеФайла.Свойство("Редактирует") и ЗначениеЗаполнено(ОписаниеФайла.Редактирует) Тогда
		ПредставлениеРедактирует = Формат(ОписаниеФайла.ДатаЗаема, "ДФ='dd.MM.yyyy HH:mm'") 
			+ " (" + ОписаниеФайла.Редактирует + ")";
		ТекущийПользователь = ИнтеграцияС1СДокументооборотПовтИсп.ТекущийПользовательДокументооборота();
		РедактируетсяТекущимПользователем =
				(ОписаниеФайла.РедактируетID = ТекущийПользователь.objectId.id);
	Иначе
		ПредставлениеРедактирует = "";
		РедактируетсяТекущимПользователем = Ложь;
		Элементы.ДекорацияРедактируется.Заголовок = ?(Редактируется, НСтр("ru = 'Редактируется'"), "");
	КонецЕсли;
	
	ТаблицаПодписей.Очистить();
	
	Подписи = ОписаниеФайла.Подписи;
	
	НомерСтроки = 0;
	Для Каждого Подпись Из ОписаниеФайла.Подписи Цикл
		
		НоваяСтрока = ТаблицаПодписей.Добавить();
		// Структура таблицы подписей универсальна.
		НоваяСтрока.КомуВыданСертификат = Подпись.КомуВыданСертификат;
		НоваяСтрока.ДатаПодписи = Подпись.ДатаПодписи;
		НоваяСтрока.Комментарий = Подпись.Комментарий;
		НоваяСтрока.Отпечаток 	= Подпись.Отпечаток;
		НоваяСтрока.УстановившийПодпись = Подпись.УстановившийПодпись;
		НоваяСтрока.Неверна 	= Ложь;
		НоваяСтрока.ИндексКартинки = -1;
		НоваяСтрока.Объект = "_";
		НоваяСтрока.ОбъектИд = ID;
		НоваяСтрока.ОбъектТип = Тип;
		
		ДвоичныеДанные = Подпись.Подпись;
		Если ДвоичныеДанные <> Неопределено Тогда 
			НоваяСтрока.АдресПодписи = ПоместитьВоВременноеХранилище(
				ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
		
		ДвоичныеДанныеСертификата = Подпись.Сертификат;
		Если ДвоичныеДанныеСертификата <> Неопределено Тогда 
			НоваяСтрока.АдресСертификата = ПоместитьВоВременноеХранилище(
				ДвоичныеДанныеСертификата, УникальныйИдентификатор);
		КонецЕсли;
		
		НоваяСтрока.ИмяФайлаПодписи = Подпись.ИмяФайлаПодписи;
		НоваяСтрока.УстановившийПодпись = Подпись.УстановившийПодпись;
		НоваяСтрока.УстановившийПодписьИд = Подпись.УстановившийПодписьИд;
		НоваяСтрока.НомерСтроки = НомерСтроки;
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	ТекстЗаголовка = НСтр("ru = 'ЭП'");
	Если ТаблицаПодписей.Количество() <> 0 Тогда
		ТекстЗаголовка = ТекстЗаголовка + " (" + Строка(ТаблицаПодписей.Количество()) + ")";
	КонецЕсли;
	Элементы.ГруппаЭП.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКоманд()
	
	Сушествует = ЗначениеЗаполнено(ID);
	
	РедактируетсяДругимПользователем = Редактируется
		И НЕ РедактируетсяТекущимПользователем;
		
	МожноЗахватить = ДоступенЗахватИРедактирование
		И НЕ РедактируетсяДругимПользователем
		И РазрешеноРедактирование;
	
	Элементы.ФормаПоказатьВСписке.Доступность = Сушествует;
	Элементы.ОткрытьНаЧтение.Доступность = Сушествует;
	Элементы.ПанельОткрытьНаЧтение.Доступность = Сушествует;
	Элементы.СохранитьНаДиск.Доступность = Сушествует;
	Элементы.ПанельСохранитьНаДиск.Доступность = Сушествует;
	Элементы.ФайловыеОперацииЕще.Доступность = Сушествует;
	Элементы.ГруппаСоздатьНаОсновании.Доступность = Сушествует;
	Элементы.ПанельОткрытьКаталогФайла.Доступность = Сушествует;
	
	Элементы.ГруппаЭП.Доступность = Сушествует;
		
	Элементы.ОткрытьДляРедактирования.Доступность = Сушествует И МожноЗахватить;
	Элементы.ПанельОткрытьДляРедактирования.Доступность = Сушествует И МожноЗахватить;
		
	Элементы.ЗакончитьРедактирование.Доступность = Сушествует И РедактируетсяТекущимПользователем;
	Элементы.ПанельЗакончитьРедактирование.Доступность = Сушествует И РедактируетсяТекущимПользователем;
	Элементы.ПанельСохранитьИзменения.Доступность = Сушествует И РедактируетсяТекущимПользователем;
	Элементы.ПанельОтменитьРедактирование.Доступность = Сушествует И РедактируетсяТекущимПользователем;
		
	Элементы.ПанельОбновитьИзФайлаНаДиске.Доступность = Сушествует И МожноЗахватить;
	
КонецПроцедуры

// Получает описание файла по идентификатору и заполняет поля формы.
//
&НаСервере
Процедура ПолучитьОписаниеФайлаИЗаполнитьФорму()
	
	Если ЗначениеЗаполнено(ID) Тогда
		ОписаниеФайла = ИнтеграцияС1СДокументооборотВызовСервера.ОписаниеФайла(ID, ЭтаФорма);
	ИначеЕсли ЗначениеЗаполнено(ОригиналID) Тогда
		АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(Неопределено,
			УникальныйИдентификатор);
		ОписаниеФайла = ИнтеграцияС1СДокументооборотВызовСервера.ОписаниеФайла(ОригиналID,
			ЭтаФорма,
			АдресВременногоХранилищаФайла);
	Иначе
		ВызватьИсключение НСтр("ru = 'Не указан идентификатор файла.'");
	КонецЕсли;
	
	ЗаполнитьФорму(ОписаниеФайла);
	УстановитьДоступностьКоманд();
	
	Элементы.Наименование.ТолькоПросмотр = Не РазрешеноРедактирование;
	Элементы.Описание.ТолькоПросмотр = Не РазрешеноРедактирование;
	
	Если ЗначениеЗаполнено(ID) Тогда
		Если ЗначениеЗаполнено(ВладелецФайла) Тогда
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (Присоединенный файл)'"), Наименование);
		Иначе
			Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 (Файл)'"), Наименование);
		КонецЕсли;
	Иначе // создание
		Если ЗначениеЗаполнено(ВладелецФайла) Тогда
			Заголовок = НСтр("ru = 'Присоединенный файл (создание)'");
		Иначе
			Заголовок = НСтр("ru = 'Файл (создание)'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет выбранную ЭП.
//
&НаСервере
Процедура ПроверитьНаСервере(ДанныеВыделенныхСтрок)
	
	АдресФайла = ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьФайлИПоместитьВХранилище(
		ID, УникальныйИдентификатор);
	ИнтеграцияС1СДокументооборотВызовСервера.ПроверитьПодписиНаСервере(
		Элементы.ТаблицаПодписей.ВыделенныеСтроки, ТаблицаПодписей, УникальныйИдентификатор, АдресФайла);
		
КонецПроцедуры

// Проверяет все ЭП.
//
&НаСервере
Процедура ПроверитьВсеНаСервере(ТаблицаПодписей) 
	
	АдресФайла = ИнтеграцияС1СДокументооборотВызовСервера.ПолучитьФайлИПоместитьВХранилище(
		ID, УникальныйИдентификатор);
	ИнтеграцияС1СДокументооборотВызовСервера.ПроверитьВсеПодписиНаСервере(
		ТаблицаПодписей, УникальныйИдентификатор, АдресФайла);
	
КонецПроцедуры

// Продолжает удаление подписей после вопроса.
//
&НаКлиенте
Процедура УдалитьЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеПодписейФайла = ИнтеграцияС1СДокументооборотКлиент.ДанныеПодписейФайла(ID, ТаблицаПодписей);
	УдалитьПодписиИОбновитьСписок(ДанныеПодписейФайла);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Событие", "ЗаписьФайла");
	Оповестить("Запись_ДокументооборотФайл", ПараметрыОповещения, "");// Идентификатор не важен.
	
	УстановитьДоступностьКомандСпискаЭП();
	
КонецПроцедуры

// Удаляет выбранные ЭП.
//
&НаСервере
Процедура УдалитьПодписиИОбновитьСписок(МассивСуществующихПодписей)
	
	НомераВыделенныхСтрок = Новый Массив;
	Для Каждого ИдентификаторСтроки Из Элементы.ТаблицаПодписей.ВыделенныеСтроки Цикл
		ВыделеннаяСтрока = ТаблицаПодписей.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если НЕ ПустаяСтрока(ВыделеннаяСтрока.Объект) Тогда
			НомераВыделенныхСтрок.Добавить(ВыделеннаяСтрока.НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	
	// Сформируем массив подписей, оставшихся после удаления.
	МассивОставшихсяПодписей = Новый Массив;
	Для Каждого ДанныеСтроки Из МассивСуществующихПодписей Цикл
		Если НомераВыделенныхСтрок.Найти(ДанныеСтроки.НомерСтроки) = Неопределено Тогда 
			МассивОставшихсяПодписей.Добавить(ДанныеСтроки);
		КонецЕсли;
	КонецЦикла;
	
	// Запишем файл с новым составом подписей.
	ЗаписатьВыполнить(МассивОставшихсяПодписей);
	
	ПолучитьОписаниеФайлаИЗаполнитьФорму();
	
КонецПроцедуры

// В зависимости от наличия подписей устанавливает доступность команд ЭП.
//
&НаКлиенте
Процедура УстановитьДоступностьКомандСпискаЭП()
	
	ЕстьПодписи = (ТаблицаПодписей.Количество() <> 0);
	
	Элементы.ТаблицаПодписейПроверить.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейПроверитьВсе.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейОткрытьПодпись.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейСохранить.Доступность = ЕстьПодписи;
	Элементы.ТаблицаПодписейУдалить.Доступность = ЕстьПодписи;
	
	Элементы.ФормаСохранитьВместеСЭП.Доступность = ЕстьПодписи;
	
КонецПроцедуры

// Записывает файл и его подписи.
//
&НаКлиенте
Процедура ЗаписатьВыполнитьКлиент(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Наименование'")),, 
			"Наименование");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ID) Тогда
		ДанныеПодписейФайла = ИнтеграцияС1СДокументооборотКлиент.ДанныеПодписейФайла(ID, ТаблицаПодписей);
		ЗаписатьВыполнить(ДанныеПодписейФайла);
	Иначе
		СоздатьИзОригинала();
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Событие", "ЗаписьФайла");
	Оповестить("Запись_ДокументооборотФайл", ПараметрыОповещения, "");// Идентификатор не важен
	
	Модифицированность = Ложь;
	
КонецПроцедуры

// Создает файл копированием оригинала.
//
&НаСервере
Процедура СоздатьИзОригинала()
	
	ПараметрыСоздания = Новый Структура;
	
	ПараметрыСоздания.Вставить("Имя", Наименование);
	ПараметрыСоздания.Вставить("Расширение", Расширение);
	ПараметрыСоздания.Вставить("ВремяИзменения", ДатаМодификацииУниверсальная);
	ПараметрыСоздания.Вставить("ВремяИзмененияУниверсальное", ДатаМодификацииУниверсальная);
	ПараметрыСоздания.Вставить("Размер", Размер);
	ПараметрыСоздания.Вставить("Текст", "");
	ПараметрыСоздания.Вставить("АдресВременногоХранилищаФайла", АдресВременногоХранилищаФайла);
	
	ID = ИнтеграцияС1СДокументооборотВызовСервера.СоздатьИзФайлаНаДискеСервер(ПараметрыСоздания,
		ВладелецID,
		ВладелецТип,
		Владелец,
		Ложь);
		
	ОригиналID = "";
	
	ПолучитьОписаниеФайлаИЗаполнитьФорму();
	
КонецПроцедуры

// Записывает файл и указанные подписи.
//
&НаСервере
Процедура ЗаписатьВыполнить(МассивСуществующихПодписейФайла)
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	ОбъектXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, Тип);
	ОбъектXDTO.objectId = ИнтеграцияС1СДокументооборот.СоздатьObjectID(Прокси, ID, Тип);
	
	// Только 2 поля, Имя и Описание передаем при записи.
	ОбъектXDTO.name = Наименование;
	ОбъектXDTO.description = Описание;
	
	Для Каждого ДанныеПодписи Из МассивСуществующихПодписейФайла Цикл
		
		ПодписьXDTO = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMSignature");
		ИнтеграцияС1СДокументооборот.ЗаполнитьXDTOПодпись(Прокси, ПодписьXDTO, ДанныеПодписи);
		ОбъектXDTO.signatures.Добавить(ПодписьXDTO);
		
	КонецЦикла;
	
	Обработки.ИнтеграцияС1СДокументооборот.СформироватьДополнительныеСвойства(Прокси, 
		ОбъектXDTO, ЭтаФорма);
	
	Ответ = ИнтеграцияС1СДокументооборот.ЗаписатьОбъект(Прокси, ОбъектXDTO);
	
КонецПроцедуры

// Общее завершение команд редактирования файла. Обновляет форму.
//
&НаКлиенте
Процедура КомандыРедактированияЗавершение(Результат, Параметры) Экспорт
	
	ПолучитьОписаниеФайлаИЗаполнитьФорму();
	
КонецПроцедуры

#КонецОбласти