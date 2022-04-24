/*
	report system
	by jax teller
*/

#include <a_samp>
#include <sscanf2>
#include <zcmd>

//main
main (){
}

/* ---------------------------------------------------------------- [ report ]*/
#define max_report 			9
#define report_str_len      256
#define report_str_min      100
new Text:report_TD[2];
new Text:reports_TD[9];
new bool:reportOn[MAX_PLAYERS] = false;

new ReportID[max_report];
new ReportName[max_report][report_str_len];
new ReportText[max_report][report_str_len];
new totalReport = 0;
/* ._. */

public OnGameModeInit()
{
    for(new i = 0; i < max_report; i ++)
	{
		ReportID[i] = -1;
		strmid(ReportName[i], "xx-xx-xx-xx", 0, strlen("xx-xx-xx-xx"), report_str_min);
	}
    LoadReportTextDraw();
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_CTRL_BACK) // key H
	{
	    if(reportOn[playerid] == false)
	        ShowReportStat(playerid);
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW && reportOn[playerid] == true)
	    HideReportStat(playerid);
	    
	for(new i = 0; i < max_report; i ++)
	{
	    if(clickedid == reports_TD[i])
	    {
	    	if(ReportID[i] == -1) return SendClientMessage(playerid, -1, "{07B284}[Report]{ffffff} Am Slot'ze Ar Aris Report");
	    	new str[report_str_len + report_str_min];
	    	format(str, report_str_len, "\n\n{07B284}Name:{ffffff} %s[%d]:\n{07B284}Kitxva/Sachivari:{ffffff} %s\n\n{07B284}Pasuxi:",ReportName[i],ReportID[i],ReportText[i]);
	    	ShowPlayerDialog(playerid, 1155, DIALOG_STYLE_INPUT, "{07B284}REPORT", str, "Shemdeg", "Gasvla");
	    	SetPVarInt(playerid, "ReportID", ReportID[i]);
	    	//
            strmid(ReportName[i], "xx-xx-xx-xx", 0, strlen("xx-xx-xx-xx"), report_str_min);
            format(str, report_str_min, "xx-xx-xx-xx");
            TextDrawSetString(reports_TD[i], str);
			ReportID[i] = -1;
			//
			totalReport --;
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 1155)
	{
	    new str[report_str_len];
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	    if(response)
	    {
			format(str, report_str_len, "{07B284}[Report Answer] %s[%d]:{ffffff} %s",name,playerid,inputtext);
			SendClientMessage(GetPVarInt(playerid, "ReportID"), -1, str);
			SendClientMessage(playerid, -1, "{07B284}[Report Answer]{ffffff} Tkven Gaecit Pasuxi Kitxva/Sachivars");
	    }
	    else
	    {
			format(str, report_str_len, "{07B284}[Report Answer] %s[%d]:{ffffff}'ma Uari Tkva Kitxva/Sachivris Ganxilvaze",name,playerid);
			SendClientMessage(GetPVarInt(playerid, "ReportID"), -1, str);
			SendClientMessage(playerid, -1, "{07B284}[Report Answer]{ffffff} Tkven Uari Tkvit Kitxva/Sachivris Ganxilvaze");
		}
	}
	return 1;
}

stock ShowReportStat(playerid)
{
	for(new i = 0; i < max_report; i ++)
	{
	    new str[report_str_min];
	    if(ReportID[i] != -1)
	    	format(str, report_str_min, "%s[%d]",ReportName[i],ReportID[i]);
		else
		    format(str, report_str_min, "xx-xx-xx-xx");
		TextDrawSetString(reports_TD[i], str);
	}
	for(new i = 0; i < 2; i ++) TextDrawShowForPlayer(playerid, report_TD[i]);
	for(new i = 0; i < 9; i ++) TextDrawShowForPlayer(playerid, reports_TD[i]);
	SelectTextDraw(playerid, 129139967);
	reportOn[playerid] = true;
	return 1;
}
stock HideReportStat(playerid)
{
	for(new i = 0; i < 2; i ++) TextDrawHideForPlayer(playerid, report_TD[i]);
	for(new i = 0; i < 9; i ++) TextDrawHideForPlayer(playerid, reports_TD[i]);
	CancelSelectTextDraw(playerid);
	reportOn[playerid] = false;
	return 1;
}

CMD:report(playerid, params[])
{
	if(totalReport >= max_report) return SendClientMessage(playerid, -1, "{07B284}[Report]{ffffff} Am Dros Ver Gagzavnit Reports");
	if(sscanf(params, "s[256]", params[0])) return SendClientMessage(playerid, -1, "{07B284}[Report]{ffffff} Gamoikenet: /report [Kitxva/Sachivari]");
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if(ReportID[totalReport] != -1){
		ReportID[totalReport + 1] = playerid;
		strmid(ReportName[totalReport + 1], name, 0, strlen(name), MAX_PLAYER_NAME);
		strmid(ReportText[totalReport + 1], params[0], 0, strlen(params[0]), report_str_min);
	}
	else{
		ReportID[totalReport] = playerid;
		strmid(ReportName[totalReport], name, 0, strlen(name), MAX_PLAYER_NAME);
		strmid(ReportText[totalReport], params[0], 0, strlen(params[0]), report_str_min);
	}
	new str[report_str_len];
	format(str, report_str_len, "{07B284}[Report]{ffffff} Tkven Gagzavnet Kitxva/Sachivari: %s",params[0]);
	SendClientMessage(playerid, -1, str);
	totalReport ++;
	return 1;
}

stock LoadReportTextDraw()
{
	report_TD[0] = TextDrawCreate(511.0000, 138.8222, "LD_SPAC:white");
	TextDrawTextSize(report_TD[0], 110.0000, 195.0000);
	TextDrawAlignment(report_TD[0], 1);
	TextDrawColor(report_TD[0], 404232447);
	TextDrawBackgroundColor(report_TD[0], 255);
	TextDrawFont(report_TD[0], 4);
	TextDrawSetProportional(report_TD[0], 0);
	TextDrawSetShadow(report_TD[0], 0);

	report_TD[1] = TextDrawCreate(568.5000, 129.6443, "REPORTS");
	TextDrawLetterSize(report_TD[1], 0.4084, 1.8737);
	TextDrawTextSize(report_TD[1], 0.0000, 54.0000);
	TextDrawAlignment(report_TD[1], 2);
	TextDrawColor(report_TD[1], 129139967);
	TextDrawBackgroundColor(report_TD[1], 255);
	TextDrawFont(report_TD[1], 2);
	TextDrawSetProportional(report_TD[1], 1);
	TextDrawSetShadow(report_TD[1], 0);

	reports_TD[0] = TextDrawCreate(565.5000, 164.4888, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[0], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[0], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[0], 2);
	TextDrawColor(reports_TD[0], -1);
	TextDrawBackgroundColor(reports_TD[0], 255);
	TextDrawFont(reports_TD[0], 1);
	TextDrawSetProportional(reports_TD[0], 1);
	TextDrawSetShadow(reports_TD[0], 0);
	TextDrawSetSelectable(reports_TD[0], true);

	reports_TD[1] = TextDrawCreate(565.5000, 181.9110, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[1], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[1], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[1], 2);
	TextDrawColor(reports_TD[1], -1);
	TextDrawBackgroundColor(reports_TD[1], 255);
	TextDrawFont(reports_TD[1], 1);
	TextDrawSetProportional(reports_TD[1], 1);
	TextDrawSetShadow(reports_TD[1], 0);
	TextDrawSetSelectable(reports_TD[1], true);

	reports_TD[2] = TextDrawCreate(565.5000, 198.7111, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[2], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[2], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[2], 2);
	TextDrawColor(reports_TD[2], -1);
	TextDrawBackgroundColor(reports_TD[2], 255);
	TextDrawFont(reports_TD[2], 1);
	TextDrawSetProportional(reports_TD[2], 1);
	TextDrawSetShadow(reports_TD[2], 0);
	TextDrawSetSelectable(reports_TD[2], true);

	reports_TD[3] = TextDrawCreate(565.5000, 214.8889, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[3], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[3], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[3], 2);
	TextDrawColor(reports_TD[3], -1);
	TextDrawBackgroundColor(reports_TD[3], 255);
	TextDrawFont(reports_TD[3], 1);
	TextDrawSetProportional(reports_TD[3], 1);
	TextDrawSetShadow(reports_TD[3], 0);
	TextDrawSetSelectable(reports_TD[3], true);

	reports_TD[4] = TextDrawCreate(566.0000, 232.9333, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[4], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[4], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[4], 2);
	TextDrawColor(reports_TD[4], -1);
	TextDrawBackgroundColor(reports_TD[4], 255);
	TextDrawFont(reports_TD[4], 1);
	TextDrawSetProportional(reports_TD[4], 1);
	TextDrawSetShadow(reports_TD[4], 0);
	TextDrawSetSelectable(reports_TD[4], true);

	reports_TD[5] = TextDrawCreate(565.5000, 250.3556, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[5], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[5], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[5], 2);
	TextDrawColor(reports_TD[5], -1);
	TextDrawBackgroundColor(reports_TD[5], 255);
	TextDrawFont(reports_TD[5], 1);
	TextDrawSetProportional(reports_TD[5], 1);
	TextDrawSetShadow(reports_TD[5], 0);
	TextDrawSetSelectable(reports_TD[5], true);

	reports_TD[6] = TextDrawCreate(566.0000, 269.0222, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[6], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[6], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[6], 2);
	TextDrawColor(reports_TD[6], -1);
	TextDrawBackgroundColor(reports_TD[6], 255);
	TextDrawFont(reports_TD[6], 1);
	TextDrawSetProportional(reports_TD[6], 1);
	TextDrawSetShadow(reports_TD[6], 0);
	TextDrawSetSelectable(reports_TD[6], true);

	reports_TD[7] = TextDrawCreate(566.0000, 285.2000, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[7], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[7], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[7], 2);
	TextDrawColor(reports_TD[7], -1);
	TextDrawBackgroundColor(reports_TD[7], 255);
	TextDrawFont(reports_TD[7], 1);
	TextDrawSetProportional(reports_TD[7], 1);
	TextDrawSetShadow(reports_TD[7], 0);
	TextDrawSetSelectable(reports_TD[7], true);

	reports_TD[8] = TextDrawCreate(564.5000, 303.2445, "xx-xx-xx-xx");
	TextDrawLetterSize(reports_TD[8], 0.2749, 1.4195);
	TextDrawTextSize(reports_TD[8], 6.0000, 54.0000);
	TextDrawAlignment(reports_TD[8], 2);
	TextDrawColor(reports_TD[8], -1);
	TextDrawBackgroundColor(reports_TD[8], 255);
	TextDrawFont(reports_TD[8], 1);
	TextDrawSetProportional(reports_TD[8], 1);
	TextDrawSetShadow(reports_TD[8], 0);
	TextDrawSetSelectable(reports_TD[8], true);
}
