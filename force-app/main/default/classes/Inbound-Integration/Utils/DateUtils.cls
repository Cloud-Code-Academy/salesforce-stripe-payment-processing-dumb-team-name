/**
 * @description Utility class for date related tasks
 *
 * @author Jonathan Lyles
 * @date August 25, 2025
 * @group Utility classes
 */
public with sharing class DateUtils {
  /**
   * @description Helper class that converts a unix timestamp into a datetime
   *
   * @return Datetime
   */
  public static Datetime timestampToDatetimeConverter(Long timestamp) {
    Datetime dt = Datetime.newInstance(timestamp * 1000L);
    return dt;
  }
}
