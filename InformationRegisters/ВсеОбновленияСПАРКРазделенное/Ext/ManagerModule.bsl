﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список доступных значений для поля "ВидОбновления".
//
// Возвращаемое значение:
//   Массив - список доступных значений.
//
Функция ПолучитьЗначенияДопустимыхВидовОбновления() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Заполнение контрагентов на мониторинге");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли