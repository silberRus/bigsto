﻿&НаСервере
Процедура УправлениеВидимостью()

	Для Каждого Элемент Из Элементы.РежимЗагрузки.СписокВыбора Цикл
		Элементы["Группа" + Элемент.Значение].Видимость = Элемент.Значение = РежимЗагрузки;
	КонецЦикла;
	
КонецПроцедуры
	
&НаСервере
Процедура ЗаполнитьПоУм(Перемен, Значение)
	
	Если Не ЗначениеЗаполнено(Перемен) Тогда
		Перемен = Значение;
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УправлениеВидимостью();
	
КонецПроцедуры

Функция ПолучитьИзСтроки(ТаблДок, НомСтроки, НомКол, Добавлено = Ложь)
	
	Текст = СОКРЛП(ТаблДок.Область(СтрШаблон("R%1C%2", формат(НомСтроки, "ЧГ="), НомКол)).Текст);
	
	Если Не ПустаяСтрока(Текст) Тогда
		Добавлено = Истина;
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции
&НаСервере
Функция НовСтруктура(Номенклатура = Неопределено, Бренд = Неопределено, Артикул = Неопределено)
	
	Возврат Новый Структура("НоменклатураСтр, БрендСтр, Артикул", Номенклатура, Бренд, Артикул);
	
КонецФункции
&НаСервере
Процедура ДобавитьДанные(Структура, Данные)
	
	Если АртикулыЧерезЗапятую Тогда
		
		Артикулы = КонвертацияТипов.ПолучитьМассивИзСтроки(Структура.Артикул, ",");
		
		Для Каждого Артикул Из Артикулы Цикл
			
			новСтруктура = НовСтруктура();
			ЗаполнитьЗначенияСвойств(новСтруктура, Структура);
			новСтруктура.Артикул = Артикул;
			
			Данные.Добавить(новСтруктура);
			
		КонецЦикла;
	Иначе
		Данные.Добавить(Структура);
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Функция ПолучитьДанные0(ТаблДок)
	
	Данные = Новый Массив;
	
	Для Ном = 1 ПО ТаблДок.ВысотаТаблицы Цикл
		
		Добавлено = Ложь;
		Структура = НовСтруктура(	ПолучитьИзСтроки(ТаблДок, Ном, НомТовар, 	Добавлено),
									ПолучитьИзСтроки(ТаблДок, Ном, НомБрэнд, 	Добавлено),
									ПолучитьИзСтроки(ТаблДок, Ном, НомАртикул, 	Добавлено));
		Если Добавлено Тогда
			//Данные.Добавить(Структура);
			ДобавитьДанные(Структура, Данные);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Данные;
	
КонецФункции
&НаСервере
Функция ПолучитьДанные1(ТаблДок)
	
	Данные = Новый Массив;
	Кроссы = Новый Массив;
	
	Для Ном = 3 ПО ТаблДок.ШиринаТаблицы Цикл
		Кроссы.Добавить(ПолучитьИзСтроки(ТаблДок, 1, Ном));
	КонецЦикла;
	
	Для НомСтроки = 2 ПО ТаблДок.ВысотаТаблицы Цикл
	
		Добавлено 	= Ложь;
		ТоварСтр 	= ПолучитьИзСтроки(ТаблДок, НомСтроки, 2, Добавлено);
		
		Если Добавлено Тогда
			Для Ном = 3 По ТаблДок.ШиринаТаблицы Цикл
				
				Добавлено = Ложь;
				Структура = НовСтруктура(	ТоварСтр,
											Кроссы[Ном - 3],
											ПолучитьИзСтроки(ТаблДок, НомСтроки, Ном, Добавлено));
				Если Добавлено Тогда
					//Данные.Добавить(Структура);
					ДобавитьДанные(Структура, Данные);
				КонецЕсли;
				
			КонецЦикла;			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Данные;
	
КонецФункции
&НаСервере
Функция ЗагрузитьТаблицуНаСервере(ОпФайла)
	
	Файл 		= Новый Файл(ОпФайла.Имя);
	ФайлТабл 	= ПолучитьИмяВременногоФайла(Файл.Расширение);
	ПолучитьИзВременногоХранилища(ОпФайла.Хранение).Записать(ФайлТабл);
	
	Данные 	= Новый Массив;
	ТаблДок = Новый ТабличныйДокумент;
	Попытка
		ТаблДок.Прочитать(ФайлТабл);
	Исключение
		ВызватьИсключение "Жопа";
	КонецПопытки;
	
	Возврат Вычислить(СтрШаблон("ПолучитьДанные%1(ТаблДок)", Формат(РежимЗагрузки, "ЧГ=;ЧН=0")));
	
КонецФункции
&НаКлиенте
Процедура ФайлПолучен(ПомещенныеФайлы, ДопПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено Тогда
		
		Закрыть(Новый Структура("РежимПоиска, Данные", РежимПоиска, ЗагрузитьТаблицуНаСервере(ПомещенныеФайлы[0])));
		
	КонецЕсли;
	
КонецПроцедуры
&НаКлиенте
Процедура Загрузить(Команда)
	
	Файлы 	= Новый Массив;
	Файл 	= Новый ОписаниеПередаваемогоФайла;
	Файл.Имя = ПутьКФайлу;
	Файлы.Добавить(Файл);
	
	НачатьПомещениеФайлов(Новый ОписаниеОповещения("ФайлПолучен", ЭтаФорма),Файлы,,Ложь);
		
КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДВ = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДВ.Фильтр = "Только openOffice или 1с (.ods, .mxl)|*.ods;*.mxl";
	ДВ.Показать(Новый ОписаниеОповещения("ФайлВыбран", ЭтаФорма));
	
КонецПроцедуры
&НаКлиенте
Процедура ФайлВыбран(ВыбранныеФайлы, ДопПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ПутьКФайлу = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьПоУм(НомТовар, 	2);
	ЗаполнитьПоУм(НомБрэнд, 	3);
	ЗаполнитьПоУм(НомАртикул, 	4);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимЗагрузкиПриИзменении(Элемент)
	
	УправлениеВидимостью();
	
КонецПроцедуры
