﻿#Область СлужебныйПрограммныйИнтерфейс

// Функция определяет необходимость выполнения замеров.
//
// Возвращаемое значение:
//  Булево - Истина выполнять, Ложь не выполнять.
//
Функция ВыполнятьЗамерыПроизводительности() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ВыполнятьЗамерыПроизводительности.Получить();
	
КонецФункции

#КонецОбласти
