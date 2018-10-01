﻿

#Область ПрограммныйИнтерфейс

Процедура ПриСозданииНаСервере_РаспоряженияНаДоставку(Форма, Отказ, СтандартнаяОбработка) Экспорт

	// Необходимо выделять заказы, по которым есть реализации в распоряжениях
	МассивДобавляемыхРеквизитов = Новый Массив;
	
	// ******   Реквизит дерева РаспоряженияНаДоставку "Реализация"    ***********		
	НовыйРеквизит = Новый РеквизитФормы("Реализация", Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг"));
	НовыйРеквизит.Путь = "РаспоряженияНаДоставку";
	НовыйРеквизит.Заголовок = "Реализация";
	МассивДобавляемыхРеквизитов.Добавить(НовыйРеквизит);
	
	Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов);
	
	ЗонаГруппаИлиПустая = (НЕ ЗначениеЗаполнено(Форма.Зона) ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Форма.Зона, "ЭтоГруппа"));
	
	ЗаполнитьРеализацииВДеревеРаспоряжений(Форма.РаспоряженияНаДоставку, ЗонаГруппаИлиПустая);
	
	/////   ЭЛЕМЕНТЫ   //////////		
	НовыйЭлемент = Форма.Элементы.Вставить("РаспоряженияНаДоставкуРеализация",
		Тип("ПолеФормы"),
		Форма.Элементы.РаспоряженияНаДоставку,
		Форма.Элементы.РаспоряженияНаДоставкуВидДокумента);
	НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	НовыйЭлемент.ПутьКДанным = "РаспоряженияНаДоставку.Реализация";	
	НовыйЭлемент.Подсказка = "Отгрузка по заказу";
	НовыйЭлемент.ТолькоПросмотр = Истина;
	//НовыйЭлемент.УстановитьДействие("ПриИзменении", "Подключаемый_ТоварыЦенаСоСкидкойПриИзменении");

КонецПроцедуры
 
Процедура ПриСозданииНаСервере_Комментарии(Форма, Отказ, СтандартнаяОбработка) Экспорт

		/////   КОМАНДЫ   //////////
//Богушевич было		
		// ******   Команда формы "ДобавитьЗаСчетПродавца"    ***********		
		//НоваяКоманда = Форма.Команды.Добавить("ДобавитьЗаСчетПродавца");
		//НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		//НоваяКоманда.Заголовок = "Добавить за счет продавца";
		//НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		//НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		//НоваяКоманда.Подсказка = "Добавить за счет продавца";
		//
		//// ******   Команда формы "ДобавитьЗаНашСчет"    ***********
		//НоваяКоманда = Форма.Команды.Добавить("ДобавитьЗаНашСчет");
		//НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		//НоваяКоманда.Заголовок = "Добавить за наш счет";
		//НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		//НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		//НоваяКоманда.Подсказка = "Добавить за наш счет";
//стало
		// ******   Команда формы "ДобавитьЗаСчетПродавца"    ***********		
		НоваяКоманда = Форма.Команды.Добавить("ДобавитьЗаСчетКлиента");
		НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		НоваяКоманда.Заголовок = "За счет клиента";
		НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		НоваяКоманда.Подсказка = "Добавить за счет клиента";
		
		// ******   Команда формы "ДобавитьЗаНашСчет"    ***********
		НоваяКоманда = Форма.Команды.Добавить("ДобавитьЗаНашСчет");
		НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		НоваяКоманда.Заголовок = "Добавить за наш счет";
		НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		НоваяКоманда.Подсказка = "Добавить за наш счет";
		
		// ******   Команда формы "ДобавитьЗаНашСчет"    ***********
		НоваяКоманда = Форма.Команды.Добавить("ДобавитьДоТерминалаТК");
		НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		НоваяКоманда.Заголовок = "До Терминала ТК";
		НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		НоваяКоманда.Подсказка = "Добавить До Терминала ТК";
				
		// ******   Команда формы "ДобавитьЗаНашСчет"    ***********
		//НоваяКоманда = Форма.Команды.Добавить("ДобавитьДоДверей");
		//НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		//НоваяКоманда.Заголовок = "До дверей";
		//НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		//НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		//НоваяКоманда.Подсказка = "Добавить До дверей";
		
		// ******   Команда формы "ДобавитьЗаНашСчет"    ***********
		НоваяКоманда = Форма.Команды.Добавить("ДобавитьНаличныйРасчёт");
		НоваяКоманда.Действие = "Подключаемый_ВыполнитьПереопределяемуюКоманду";
		НоваяКоманда.Заголовок = "Наличный расчёт";
		НоваяКоманда.ИзменяетСохраняемыеДанные = Ложь;
		НоваяКоманда.Отображение = ОтображениеКнопки.Авто;
		НоваяКоманда.Подсказка = "Добавить Наличный расчёт";
		
//конец
		/////   ЭЛЕМЕНТЫ   //////////		
//Богушевич	было	
		//НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставка1",
		//	Тип("ГруппаФормы"),
		//	Форма.Элементы.ГруппаДоставкаДоПолучателяДопИнфо1,
		//	Неопределено);
		//НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		////НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		//НовыйЭлемент.ОтображатьЗаголовок = Ложь;
		//НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаСчетПродавца1",
		//	Тип("КнопкаФормы"),
		//	Форма.Элементы.СТ_ГруппаДоставка1,
		//	Неопределено);
		//НовыйЭлемент.Заголовок = "Наличный расчет";
		//НовыйЭлемент.ИмяКоманды = "ДобавитьЗаСчетПродавца";
		////НовыйЭлемент.Высота = 4;
		////НовыйЭлемент.Ширина = 7;
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаНашСчет1",
		//	Тип("КнопкаФормы"),
		//	Форма.Элементы.СТ_ГруппаДоставка1,
		//	Форма.Элементы.КнопкаЗаСчетПродавца1);
		//НовыйЭлемент.Заголовок = "ЗА НАШ СЧЁТ";
		//НовыйЭлемент.ИмяКоманды = "ДобавитьЗаНашСчет";
				
		// ******   Группа формы "СТ_ГруппаДоставка2"    ***********
		
		//НовыйЭлемент = Форма.Элементы.Добавить("СТ_ГруппаДоставка2",
		//	Тип("ГруппаФормы"),
		//	Форма.Элементы.ГруппаДоставкаДоПолучателяДопИнфо2);
		//НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		////НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		//НовыйЭлемент.ОтображатьЗаголовок = Ложь;
		//НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаСчетПродавца2",
		//	Тип("КнопкаФормы"),
		//	Форма.Элементы.СТ_ГруппаДоставка2,
		//	Неопределено);
		//НовыйЭлемент.Заголовок = "Наличный расчет";
		//НовыйЭлемент.ИмяКоманды = "ДобавитьЗаСчетПродавца";
		////НовыйЭлемент.Высота = 4;
		////НовыйЭлемент.Ширина = 7;
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаНашСчет2",
		//	Тип("КнопкаФормы"),
		//	Форма.Элементы.СТ_ГруппаДоставка2,
		//	Форма.Элементы.КнопкаЗаСчетПродавца2);
		//НовыйЭлемент.Заголовок = "ЗА НАШ СЧЁТ";
		//НовыйЭлемент.ИмяКоманды = "ДобавитьЗаНашСчет";
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставка",
		//	Тип("ГруппаФормы"),
		//	Форма.Элементы.ГруппаДоставкаДоПолучателяДопИнфо,
		//	Неопределено);
		//НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		////НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		//НовыйЭлемент.ОтображатьЗаголовок = Ложь;
		//НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаСчетПродавца",
		//	Тип("КнопкаФормы"),
		//	Форма.Элементы.СТ_ГруппаДоставка,
		//	Неопределено);
		//НовыйЭлемент.Заголовок = "Наличный расчет";
		//НовыйЭлемент.ИмяКоманды = "ДобавитьЗаСчетПродавца";
		////НовыйЭлемент.Высота = 4;
		////НовыйЭлемент.Ширина = 7;
		//
		//НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаНашСчет",
		//	Тип("КнопкаФормы"),
		//	Форма.Элементы.СТ_ГруппаДоставка,
		//	Форма.Элементы.КнопкаЗаСчетПродавца);
		//НовыйЭлемент.Заголовок = "ЗА НАШ СЧЁТ";
		//НовыйЭлемент.ИмяКоманды = "ДобавитьЗаНашСчет";
//стало
		ДобавитьГруппыДляКнопокДоставки(Форма,"1");
		ДобавитьГруппыДляКнопокДоставки(Форма,"2");             
		ДобавитьГруппыДляКнопокДоставки(Форма,"");
		ДобавитьКнопкиКомментариевДоставки(Форма,"1");
		ДобавитьКнопкиКомментариевДоставки(Форма,"2");
		ДобавитьКнопкиКомментариевДоставки(Форма,"");
//Конец
		
КонецПроцедуры

Процедура ДобавитьКнопкиКомментариевДоставки(Форма,СЧ)

	НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаСчетКлиента"+СЧ,
		Тип("КнопкаФормы"),
		Форма.Элементы["СТ_ГруппаДоставкаСамаяВерхняя"+СЧ],
		Неопределено);
	НовыйЭлемент.Заголовок = ВРег("За счет клиента");
	НовыйЭлемент.ИмяКоманды = "ДобавитьЗаСчетКлиента";
	НовыйЭлемент.Высота = 2;
	НовыйЭлемент.Ширина = 17;
	НовыйЭлемент.ЦветФона = Новый Цвет(112,173,71);
	
	НовыйЭлемент = Форма.Элементы.Вставить("КнопкаЗаНашСчет"+СЧ,
		Тип("КнопкаФормы"),
		Форма.Элементы["СТ_ГруппаДоставкаВерхняя"+СЧ],
		Неопределено);
	НовыйЭлемент.Заголовок = ВРег("За наш счет");
	НовыйЭлемент.ИмяКоманды = "ДобавитьЗаНашСчет";
	НовыйЭлемент.Высота = 2;
	НовыйЭлемент.Ширина = 17;
	НовыйЭлемент.ЦветФона = Новый Цвет(237,125,49);

	НовыйЭлемент = Форма.Элементы.Вставить("ДобавитьДоТерминалаТК"+СЧ,
		Тип("КнопкаФормы"),
		Форма.Элементы["СТ_ГруппаДоставкаСредняя"+СЧ],
		Неопределено);
	НовыйЭлемент.Заголовок = "До терминала ТК";
	НовыйЭлемент.ИмяКоманды = "ДобавитьДоТерминалаТК";
	НовыйЭлемент.Высота = 2;
	НовыйЭлемент.Ширина = 17;
	НовыйЭлемент.ЦветФона = Новый Цвет(165,165,165);

	//НовыйЭлемент = Форма.Элементы.Вставить("ДобавитьДоДверей"+СЧ,
	//	Тип("КнопкаФормы"),
	//	Форма.Элементы["СТ_ГруппаДоставкаСредняя"+СЧ],
	//	Неопределено);
	//НовыйЭлемент.Заголовок = "До дверей";
	//НовыйЭлемент.ИмяКоманды = "ДобавитьДоДверей";
	//НовыйЭлемент.Высота = 2;
	//НовыйЭлемент.Ширина = 17;
	//НовыйЭлемент.ЦветФона = Новый Цвет(165,165,165);

	НовыйЭлемент = Форма.Элементы.Вставить("ДобавитьНаличныйРасчёт"+СЧ,
		Тип("КнопкаФормы"),
		Форма.Элементы["СТ_ГруппаДоставкаНижняя"+СЧ],
		Неопределено);
	НовыйЭлемент.Заголовок = "Наличный расчет";
	НовыйЭлемент.ИмяКоманды = "ДобавитьНаличныйРасчёт";
	НовыйЭлемент.Высота = 2;
	НовыйЭлемент.Ширина = 17;
	//НовыйЭлемент.ЦветФона = Новый Цвет(247,188,164);

КонецПроцедуры

Процедура ДобавитьГруппыДляКнопокДоставки(Форма,СЧ)
	
	НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставка"+СЧ,
		Тип("ГруппаФормы"),
		Форма.Элементы["ГруппаДоставкаДоПолучателяДопИнфо"+СЧ],
		Неопределено);
	НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	НовыйЭлемент.ОтображатьЗаголовок = Ложь;
	НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставкаСамаяВерхняя"+СЧ,
	Тип("ГруппаФормы"),
	Форма.Элементы["СТ_ГруппаДоставка"+СЧ],
	Неопределено);
	НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	НовыйЭлемент.ОтображатьЗаголовок = Ложь;
	НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставкаВерхняя"+СЧ,
	Тип("ГруппаФормы"),
	Форма.Элементы["СТ_ГруппаДоставка"+СЧ],
	Неопределено);
	НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	НовыйЭлемент.ОтображатьЗаголовок = Ложь;
	НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставкаСредняя"+СЧ,
	Тип("ГруппаФормы"),
	Форма.Элементы["СТ_ГруппаДоставка"+СЧ],
	Неопределено);
	НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	НовыйЭлемент.ОтображатьЗаголовок = Ложь;
	НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;
	
	НовыйЭлемент = Форма.Элементы.Вставить("СТ_ГруппаДоставкаНижняя"+СЧ,
	Тип("ГруппаФормы"),
	Форма.Элементы["СТ_ГруппаДоставка"+СЧ],
	Неопределено);
	НовыйЭлемент.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлемент.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	НовыйЭлемент.ОтображатьЗаголовок = Ложь;
	НовыйЭлемент.Отображение = ОтображениеОбычнойГруппы.Нет;

КонецПроцедуры

// Заполняет программно добавленную колонку "Реализация" в дереве распоряжений на доставку.
//
// Параметры:
//	РаспоряженияНаДоставку - ДанныеФормыДерево - распоряжения на доставку,
//  ЗонаГруппаИлиПустая - Булево - признак того, что в отборе по зоне доставки установлена группа или этот отбор не заполнен.
//
Процедура ЗаполнитьРеализацииВДеревеРаспоряжений(РаспоряженияНаДоставку, ЗонаГруппаИлиПустая) Экспорт

	ВерхниеСтрокиДерева = РаспоряженияНаДоставку.ПолучитьЭлементы();
	
	Если ВерхниеСтрокиДерева.Количество() = 0
		Или НЕ ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ВерхниеСтрокиДерева[0], "Реализация") Тогда
		Возврат;
	КонецЕсли;	
	
	МассивРаспоряжений = Новый Массив;
	Если ЗонаГруппаИлиПустая Тогда
		Для каждого СтрокаЗонаДоставки из ВерхниеСтрокиДерева Цикл
			ЗаполнитьМассивРаспоряженийНижнийУровень(СтрокаЗонаДоставки.ПолучитьЭлементы(), МассивРаспоряжений)
		КонецЦикла;
	Иначе
		ЗаполнитьМассивРаспоряженийНижнийУровень(ВерхниеСтрокиДерева, МассивРаспоряжений)
	КонецЕсли;
	
	РеализацииПоРаспоряжениям = ПолучитьТаблицуРеализацийПоРаспоряжениям(МассивРаспоряжений);
	
	Если ЗонаГруппаИлиПустая Тогда
		Для каждого СтрокаЗонаДоставки из ВерхниеСтрокиДерева Цикл
			ЗаполнитьРеализацииРаспоряженийНижнийУровень(СтрокаЗонаДоставки.ПолучитьЭлементы(), РеализацииПоРаспоряжениям)
		КонецЦикла;
	Иначе
		ЗаполнитьРеализацииРаспоряженийНижнийУровень(ВерхниеСтрокиДерева, РеализацииПоРаспоряжениям)
	КонецЕсли;	

КонецПроцедуры
 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРеализацииРаспоряженийНижнийУровень(КоллекцияСтрокДерева, РеализацииПоРаспоряжениям)
	
	Для каждого Строка из КоллекцияСтрокДерева Цикл
		СтрокаРеализацииПоРаспоряжениям = РеализацииПоРаспоряжениям.Найти(Строка.Распоряжение, "Распоряжение");
		Если ЗначениеЗаполнено(СтрокаРеализацииПоРаспоряжениям) Тогда
			Строка.Реализация = СтрокаРеализацииПоРаспоряжениям.Реализация;			
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМассивРаспоряженийНижнийУровень(КоллекцияСтрокДерева, МассивРаспоряжений)
	
	Для каждого Строка из КоллекцияСтрокДерева Цикл
		МассивРаспоряжений.Добавить(Строка.Распоряжение);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТаблицуРеализацийПоРаспоряжениям(МассивРаспоряжений)
	
	ТаблицаРезультат = Неопределено;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслуг.ЗаказКлиента КАК Распоряжение,
		|	МАКСИМУМ(РеализацияТоваровУслуг.Ссылка) КАК Реализация
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.ЗаказКлиента В(&МассивРаспоряжений)
		|	И РеализацияТоваровУслуг.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.Заказклиента.ПустаяСсылка)
		|	И РеализацияТоваровУслуг.Проведен
		|
		|СГРУППИРОВАТЬ ПО
		|	РеализацияТоваровУслуг.ЗаказКлиента";
	
	Запрос.УстановитьПараметр("МассивРаспоряжений", МассивРаспоряжений);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	//Если НЕ РезультатЗапроса.Пустой() Тогда silber (закоментарил так как функция должна всегда возвращать 1 тип
		ТаблицаРезультат = РезультатЗапроса.Выгрузить();
		ТаблицаРезультат.Индексы.Добавить("Распоряжение");
	//КонецЕсли; 
	
	Возврат ТаблицаРезультат;	

КонецФункции // ()

#КонецОбласти
