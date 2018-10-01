﻿////////////////////////////////////////////////////////////////////////////////
// Действия при изменении константы.
//  
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	// При записи преднамеренно не используется ОбменДанными.Загрузка.
	// Причина в том, что по РИБ может перемещаться только константа
	// "Использовать сервис проверки данных по контрагенту".
	// После того, как константа попадет в узел, должно быть включено
	// регламентное задание для периодической проверки контрагентов.
	
	// Включаем/отключаем рег задание в зависимости от выбора пользователя.
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ПроверкаКонтрагентов,
		ПроверкаКонтрагентов.ПроверкаКонтрагентовВключена());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

