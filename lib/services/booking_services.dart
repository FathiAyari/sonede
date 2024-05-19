import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umbrella/models/booking.dart';

class BookingServices {
  static Future<bool> allowBooking({required DateTime startDate, required DateTime endDate, required String idUmbrella}) async {
    bool allowAction = true;
    var bookings = await FirebaseFirestore.instance
        .collection('booking')
        .where("umbrellaId", isEqualTo: idUmbrella)
        .where("status", isEqualTo: 1)
        .get();
    List<Booking> bookingList = [];
    for (var data in bookings.docs.toList()) {
      bookingList.add(Booking.fromJson(data.data()));
    }
    for (Booking booking in bookingList) {
      if ((startDate.isBefore(booking.startDate) && endDate.isAfter(booking.startDate)) ||
          (startDate.isBefore(booking.endDate) && endDate.isAfter(booking.endDate)) ||
          (startDate.isAfter(booking.startDate) && endDate.isBefore(booking.endDate)) ||
          (startDate.year == booking.startDate.year &&
              startDate.month == booking.startDate.month &&
              startDate.day == booking.startDate.day) ||
          (startDate.year == booking.startDate.year &&
              startDate.month == booking.startDate.month &&
              startDate.day == booking.startDate.day &&
              endDate.year == booking.endDate.year &&
              endDate.month == booking.endDate.month &&
              endDate.day == booking.endDate.day)) {
        allowAction = false;
      }
      print(startDate.year == booking.startDate.year &&
          startDate.month == booking.startDate.month &&
          startDate.day == booking.startDate.day &&
          endDate.year == booking.endDate.year &&
          endDate.month == booking.endDate.month &&
          endDate.day == booking.endDate.day);
    }
    return allowAction;
  }
}
