import 'package:flutter/material.dart';
import 'package:job_hive/constants/colors.dart';
import 'package:job_hive/core/auth/auth_methods.dart';
import 'package:job_hive/features/user_profile/widgets/achievement_details.dart';
import 'package:job_hive/features/user_profile/widgets/basic_details.dart';
import 'package:job_hive/features/user_profile/widgets/education_details.dart';
import 'package:job_hive/features/user_profile/widgets/experience_details.dart';
import 'package:job_hive/features/user_profile/widgets/custom_chip.dart';
import 'package:job_hive/features/user_profile/widgets/project_details.dart';
import 'package:job_hive/features/user_profile/widgets/title_widget.dart';
import 'package:job_hive/models/user.dart';
import 'package:job_hive/provider/user_provider.dart';
import 'package:job_hive/utils/helpers/show_modal_sheet.dart';
import 'package:job_hive/utils/services/user_api_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatelessWidget {
  static const routeName = '/userProfileScreen';
  final Map<String, dynamic> data;
  const UserProfileScreen({this.data = const {}, super.key});

  @override
  Widget build(BuildContext context) {
    final user = data.isEmpty
        ? Provider.of<UserProvider>(context).user
        : User.fromJson(data);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final pref = await SharedPreferences.getInstance();
          String token = pref.getString('token')!;
          if (context.mounted) {
            await UserAPIServices.getUser(token, context);
          }
        },
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              actions: data.isNotEmpty
                  ? null
                  : [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          showCustomBottomSheet(
                            'Name',
                            'Profession',
                            'About',
                            'Name',
                            context,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/loginScreen',
                            (route) => false,
                          );
                          AuthMethods.logoutUser(context);
                        },
                      ),
                    ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Image.network(
                  'https://cdn8.dissolve.com/p/D1061_155_336/D1061_155_336_1200.jpg',
                  fit: BoxFit.cover,
                ),
                title: Text(
                  user!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BasicDetails(iconData: Icons.mail, content: user.email),
                      if (user.profession != '')
                        BasicDetails(
                            iconData: Icons.person, content: user.profession!),
                      if (user.about != '')
                        BasicDetails(
                            iconData: Icons.info, content: user.about!),
                    ],
                  ),
                ),
              ),
            ),
            TitleWidget(
                title: 'Skills',
                onPressed: data.isNotEmpty
                    ? () {}
                    : () {
                        showCustomBottomSheet(
                            'Skill', '', '', 'Skill', context);
                      }),
            SliverGrid.builder(
              itemCount: user.skills!.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomChip(user.skills![index], 'skills'),
                );
              },
            ),
            TitleWidget(
                title: 'Experience',
                onPressed: data.isNotEmpty
                    ? () {}
                    : () {
                        showCustomBottomSheet(
                          'Company',
                          'Position',
                          'Description',
                          'Experience',
                          context,
                        );
                      }),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ExperienceDetails(
                      company: user.experience![index]['company'],
                      position: user.experience![index]['position'],
                      description: user.experience![index]['description'],
                      experienceId: user.experience![index]['_id']);
                },
                childCount: user.experience!.length,
              ),
            ),
            TitleWidget(
                title: 'Education',
                onPressed: data.isNotEmpty
                    ? () {}
                    : () {
                        showCustomBottomSheet(
                            'Institute', 'Degree', '', 'Education', context);
                      }),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return EducationDetails(
                  user.education![index]['institute'],
                  user.education![index]['degree'],
                  user.education![index]['_id'],
                );
              }, childCount: user.education!.length),
            ),
            TitleWidget(
                title: 'Projects',
                onPressed: data.isNotEmpty
                    ? () {}
                    : () {
                        showCustomBottomSheet(
                            'Title', 'Description', '', 'Project', context);
                      }),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => ProjectDetails(
                  projectId: user.project![index]['_id'],
                  title: user.project![index]['title'],
                  description: user.project![index]['description'],
                ),
                childCount: user.project!.length,
              ),
            ),
            TitleWidget(
                title: 'Achievements',
                onPressed: data.isNotEmpty
                    ? () {}
                    : () {
                        showCustomBottomSheet(
                            'Title', 'Description', '', 'Achievement', context);
                      }),
            SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return AchievementDetails(
                    title: user.achievement![index]['title'],
                    description: user.achievement![index]['description'],
                    achievementId: user.achievement![index]['_id']);
              },
              itemCount: user.achievement!.length,
            ),
            TitleWidget(
                title: 'Languages',
                onPressed: data.isNotEmpty
                    ? () {}
                    : () {
                        showCustomBottomSheet(
                            'Language', '', '', 'Language', context);
                      }),
            SliverGrid.builder(
              itemCount: user.languages!.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomChip(user.languages![index], 'languages'),
                );
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
