    public class PressureConverter : IValueConverter
    {
        public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
            => value is double d ? $"{d * 0.75006:F0} мм рт.ст." : "-";

        public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
            => throw new NotImplementedException();
    }

    public class WindDirectionConverter : IValueConverter
    {
        private static readonly string[] directions = {
            "С", "ССВ", "СВ", "ВСВ", "В", "ВЮВ", "ЮВ", "ЮЮВ",
            "Ю", "ЮЮЗ", "ЮЗ", "ЗЮЗ", "З", "ЗСЗ", "СЗ", "ССЗ"
        };

        public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
            => value is double deg ? directions[(int)Math.Round(deg / 22.5) % 16] : "-";

        public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
            => throw new NotImplementedException();
    }
