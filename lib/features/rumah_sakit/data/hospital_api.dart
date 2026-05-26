import 'package:majadigi/core/theme/api_config.dart';
import 'package:majadigi/core/theme/api_service.dart';

class Hospital {
  final int id;
  final String name;
  final String? address;
  final String? city;
  final String? description;
  final String? phone;
  final String? websiteUrl;
  final String? logoUrl;

  Hospital({
    required this.id,
    required this.name,
    this.address,
    this.city,
    this.description,
    this.phone,
    this.websiteUrl,
    this.logoUrl,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name'] ?? '',
      address: json['address'],
      city: json['city'],
      description: json['description'],
      phone: json['phone'],
      websiteUrl: json['website_url'] ?? json['websiteUrl'],
      logoUrl: json['logo_url'] ?? json['logoUrl'],
    );
  }
}

class Polyclinic {
  final int id;
  final int hospitalId;
  final String name;

  Polyclinic({required this.id, required this.hospitalId, required this.name});

  factory Polyclinic.fromJson(Map<String, dynamic> json) {
    return Polyclinic(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      hospitalId: (json['hospital_id'] ?? 0) is int ? json['hospital_id'] : int.tryParse('${json['hospital_id']}') ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Doctor {
  final int id;
  final int polyclinicId;
  final String name;
  final String? title;

  Doctor({required this.id, required this.polyclinicId, required this.name, this.title});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      polyclinicId: (json['polyclinic_id'] ?? 0) is int ? json['polyclinic_id'] : int.tryParse('${json['polyclinic_id']}') ?? 0,
      name: json['name'] ?? '',
      title: json['title'],
    );
  }
}

class DoctorSchedule {
  final int id;
  final int doctorId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final int maxPatients;
  final int currentPatients;

  DoctorSchedule({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.maxPatients,
    required this.currentPatients,
  });

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) {
    return DoctorSchedule(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      doctorId: (json['doctor_id'] ?? 0) is int ? json['doctor_id'] : int.tryParse('${json['doctor_id']}') ?? 0,
      dayOfWeek: json['day_of_week'] ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      maxPatients: (json['max_patients'] ?? 0) is int ? json['max_patients'] : int.tryParse('${json['max_patients']}') ?? 0,
      currentPatients: (json['current_patients'] ?? 0) is int ? json['current_patients'] : int.tryParse('${json['current_patients']}') ?? 0,
    );
  }
}

class RoomAvailabilitySummary {
  final int total;
  final int available;

  RoomAvailabilitySummary({required this.total, required this.available});

  factory RoomAvailabilitySummary.fromJson(Map<String, dynamic> json) {
    final total = json['total'];
    final available = json['available'];
    return RoomAvailabilitySummary(
      total: total is int ? total : int.tryParse('$total') ?? 0,
      available: available is int ? available : int.tryParse('$available') ?? 0,
    );
  }
}

class RoomAvailabilityDetail {
  final int id;
  final int hospitalId;
  final String roomName;
  final String roomClass;
  final int totalBeds;
  final int availableBeds;

  RoomAvailabilityDetail({
    required this.id,
    required this.hospitalId,
    required this.roomName,
    required this.roomClass,
    required this.totalBeds,
    required this.availableBeds,
  });

  factory RoomAvailabilityDetail.fromJson(Map<String, dynamic> json) {
    return RoomAvailabilityDetail(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      hospitalId: (json['hospital_id'] ?? 0) is int ? json['hospital_id'] : int.tryParse('${json['hospital_id']}') ?? 0,
      roomName: json['room_name'] ?? '',
      roomClass: json['room_class'] ?? '',
      totalBeds: (json['total_beds'] ?? 0) is int ? json['total_beds'] : int.tryParse('${json['total_beds']}') ?? 0,
      availableBeds: (json['available_beds'] ?? 0) is int ? json['available_beds'] : int.tryParse('${json['available_beds']}') ?? 0,
    );
  }
}

class RoomAvailabilityResponse {
  final RoomAvailabilitySummary summary;
  final List<RoomAvailabilityDetail> details;

  RoomAvailabilityResponse({required this.summary, required this.details});

  factory RoomAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    final summaryJson = (json['summary'] as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    final detailsJson = json['details'];
    final details = detailsJson is List
        ? detailsJson.whereType<Map>().map((e) => RoomAvailabilityDetail.fromJson(e.cast<String, dynamic>())).toList()
        : const <RoomAvailabilityDetail>[];
    return RoomAvailabilityResponse(summary: RoomAvailabilitySummary.fromJson(summaryJson), details: details);
  }
}

class QueueBooking {
  final int id;
  final String queueNumber;
  final String scheduleDate;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String doctorName;
  final String? doctorTitle;
  final String polyclinicName;
  final String hospitalName;
  final String patientName;
  final String patientNik;
  final String patientBirthDate;

  QueueBooking({
    required this.id,
    required this.queueNumber,
    required this.scheduleDate,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.doctorName,
    required this.doctorTitle,
    required this.polyclinicName,
    required this.hospitalName,
    required this.patientName,
    required this.patientNik,
    required this.patientBirthDate,
  });

  factory QueueBooking.fromJson(Map<String, dynamic> json) {
    return QueueBooking(
      id: (json['id'] ?? 0) is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      queueNumber: (json['queue_number'] ?? '').toString(),
      scheduleDate: (json['schedule_date'] ?? '').toString(),
      dayOfWeek: (json['day_of_week'] ?? '').toString(),
      startTime: (json['start_time'] ?? '').toString(),
      endTime: (json['end_time'] ?? '').toString(),
      doctorName: (json['doctor_name'] ?? '').toString(),
      doctorTitle: json['doctor_title']?.toString(),
      polyclinicName: (json['polyclinic_name'] ?? '').toString(),
      hospitalName: (json['hospital_name'] ?? '').toString(),
      patientName: (json['patient_name'] ?? '').toString(),
      patientNik: (json['patient_nik'] ?? '').toString(),
      patientBirthDate: (json['patient_birth_date'] ?? '').toString(),
    );
  }
}

class HospitalApi {
  final ApiService _api = ApiService();

  Future<List<Hospital>> getHospitals({String? city}) async {
    final endpoint = city == null || city.isEmpty ? ApiConfig.hospitals : '${ApiConfig.hospitals}?city=$city';
    final response = await _api.get(endpoint, authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.whereType<Map>().map((e) => Hospital.fromJson(e.cast<String, dynamic>())).toList();
    }
    return const [];
  }

  Future<Hospital?> getHospital(int id) async {
    final response = await _api.get(ApiConfig.hospitalDetail(id), authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is Map) return Hospital.fromJson(data.cast<String, dynamic>());
    return null;
  }

  Future<List<Polyclinic>> getPolyclinics(int hospitalId) async {
    final response = await _api.get(ApiConfig.hospitalPolyclinics(hospitalId), authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.whereType<Map>().map((e) => Polyclinic.fromJson(e.cast<String, dynamic>())).toList();
    }
    return const [];
  }

  Future<List<Doctor>> getDoctors(int polyclinicId) async {
    final response = await _api.get(ApiConfig.polyclinicDoctors(polyclinicId), authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.whereType<Map>().map((e) => Doctor.fromJson(e.cast<String, dynamic>())).toList();
    }
    return const [];
  }

  Future<List<DoctorSchedule>> getSchedules(int doctorId) async {
    final response = await _api.get(ApiConfig.doctorSchedules(doctorId), authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.whereType<Map>().map((e) => DoctorSchedule.fromJson(e.cast<String, dynamic>())).toList();
    }
    return const [];
  }

  Future<RoomAvailabilityResponse> getRooms(int hospitalId) async {
    final response = await _api.get(ApiConfig.hospitalRooms(hospitalId), authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is Map) return RoomAvailabilityResponse.fromJson(data.cast<String, dynamic>());
    return RoomAvailabilityResponse(summary: RoomAvailabilitySummary(total: 0, available: 0), details: const []);
  }

  Future<List<String>> getOperationalInfo(int hospitalId, {String? category}) async {
    final endpoint = category == null || category.isEmpty
        ? ApiConfig.hospitalInfo(hospitalId)
        : '${ApiConfig.hospitalInfo(hospitalId)}?category=$category';
    final response = await _api.get(endpoint, authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.map((e) {
        if (e is Map) return (e['content'] ?? '').toString();
        return '$e';
      }).where((e) => e.trim().isNotEmpty).toList();
    }
    return const [];
  }

  Future<int> createQueue({
    required int scheduleId,
    required String queueNumber,
    required String scheduleDate, // YYYY-MM-DD
    required String patientName,
    required String patientNik,
    required String patientBirthDate, // YYYY-MM-DD
  }) async {
    final response = await _api.post(
      ApiConfig.queues,
      authenticated: true,
      body: {
        'scheduleId': scheduleId,
        'queueNumber': queueNumber,
        'scheduleDate': scheduleDate,
        'patientName': patientName,
        'patientNik': patientNik,
        'patientBirthDate': patientBirthDate,
      },
    );
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is Map) {
      final queueId = data['queueId'];
      return queueId is int ? queueId : int.tryParse('$queueId') ?? 0;
    }
    return 0;
  }

  Future<List<QueueBooking>> getMyQueues() async {
    final response = await _api.get(ApiConfig.myQueues, authenticated: true);
    final data = response is Map<String, dynamic> ? response['data'] : null;
    if (data is List) {
      return data.whereType<Map>().map((e) => QueueBooking.fromJson(e.cast<String, dynamic>())).toList();
    }
    return const [];
  }
}
