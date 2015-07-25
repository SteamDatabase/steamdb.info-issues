-- This is a partical database structure dump used by SteamDB
-- This structure is not final and can change at any time

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `Apps` (
  `AppID` int(7) unsigned NOT NULL,
  `AppType` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'SteamDB Unknown App',
  `StoreName` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `LastKnownName` varchar(150) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastDepotUpdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `AppsHistory` (
  `ID` int(9) unsigned NOT NULL,
  `ChangeID` int(9) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('created_app','deleted_app','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) unsigned NOT NULL DEFAULT '0',
  `OldValue` mediumtext COLLATE utf8_bin NOT NULL,
  `NewValue` mediumtext COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `AppsInfo` (
  `AppID` int(7) unsigned NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `Value` mediumtext COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `AppsTypes` (
  `AppType` tinyint(2) unsigned NOT NULL,
  `Name` varbinary(15) NOT NULL,
  `DisplayName` varchar(30) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO `AppsTypes` (`AppType`, `Name`, `DisplayName`) VALUES
(0, 'unknown', 'Unknown'),
(1, 'game', 'Game'),
(2, 'application', 'Application'),
(3, 'demo', 'Demo'),
(4, 'dlc', 'DLC'),
(5, 'tool', 'Tool'),
(6, 'depotonly', 'Depot (not used)'),
(7, 'guide', 'Guide'),
(8, 'media', 'Legacy Media'),
(9, 'config', 'Config'),
(10, 'driver', 'Driver'),
(11, 'film', 'Film'),
(12, 'tvseries', 'TV Series'),
(13, 'video', 'Video'),
(14, 'plugin', 'Plugin'),
(15, 'music', 'Music'),
(16, 'hardware', 'Hardware');

CREATE TABLE IF NOT EXISTS `Changelists` (
  `ID` int(10) unsigned NOT NULL,
  `ChangeID` int(11) unsigned NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ChangelistsApps` (
  `ID` int(11) unsigned NOT NULL,
  `ChangeID` int(11) unsigned NOT NULL,
  `AppID` int(11) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ChangelistsSubs` (
  `ID` int(11) unsigned NOT NULL,
  `ChangeID` int(11) unsigned NOT NULL,
  `SubID` int(11) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Depots` (
  `DepotID` int(7) unsigned NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown Depot',
  `BuildID` int(7) unsigned NOT NULL DEFAULT '0',
  `ManifestID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Displayed on the website, used for history',
  `LastManifestID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Only updated after file list was successfully updated',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `DepotsFiles` (
  `ID` int(9) unsigned NOT NULL,
  `DepotID` int(7) unsigned NOT NULL,
  `File` varchar(255) COLLATE utf8_bin NOT NULL,
  `Hash` char(40) COLLATE utf8_bin NOT NULL DEFAULT '0000000000000000000000000000000000000000',
  `Size` bigint(20) unsigned NOT NULL,
  `Flags` int(5) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `DepotsHistory` (
  `ID` int(9) unsigned NOT NULL,
  `ChangeID` int(9) unsigned NOT NULL,
  `DepotID` int(7) unsigned NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('added','removed','modified','modified_flags','manifest_change','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `File` varchar(300) COLLATE utf8_bin NOT NULL,
  `OldValue` bigint(20) unsigned NOT NULL,
  `NewValue` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `DepotsKeys` (
  `DepotID` int(7) unsigned NOT NULL,
  `Key` varchar(64) COLLATE utf8_bin NOT NULL,
  `LastUpdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `GC` (
  `AppID` int(7) unsigned NOT NULL,
  `Status` varchar(80) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ImportantApps` (
  `ID` int(4) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Channel` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `ImportantSubs` (
  `SubID` int(7) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `KeyNames` (
  `ID` smallint(4) unsigned NOT NULL,
  `Type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(120) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `KeyNamesSubs` (
  `ID` smallint(4) unsigned NOT NULL,
  `Type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(90) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `PICSTokens` (
  `AppID` int(7) NOT NULL,
  `Token` bigint(20) unsigned NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CommunityID` bigint(17) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `RSS` (
  `ID` int(11) NOT NULL,
  `Title` varchar(255) COLLATE utf8_bin NOT NULL,
  `Link` varchar(300) COLLATE utf8_bin NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `StoreUpdateQueue` (
  `ID` int(7) unsigned NOT NULL,
  `Type` enum('app','sub') COLLATE utf8_bin NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `Subs` (
  `SubID` int(7) unsigned NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown Package',
  `StoreName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastKnownName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SubsApps` (
  `SubID` int(7) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Type` enum('app','depot') COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SubsHistory` (
  `ID` int(9) unsigned NOT NULL,
  `ChangeID` int(9) unsigned NOT NULL,
  `SubID` int(7) unsigned NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('created_sub','deleted_sub','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `OldValue` text COLLATE utf8_bin NOT NULL,
  `NewValue` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE IF NOT EXISTS `SubsInfo` (
  `SubID` int(7) unsigned NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `Value` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE `Apps`
 ADD UNIQUE KEY `AppID` (`AppID`), ADD KEY `LastUpdated` (`LastUpdated`), ADD KEY `AppType` (`AppType`), ADD FULLTEXT KEY `Name` (`Name`,`StoreName`,`LastKnownName`);

ALTER TABLE `AppsHistory`
 ADD PRIMARY KEY (`ID`), ADD KEY `AppID` (`AppID`);

ALTER TABLE `AppsInfo`
 ADD UNIQUE KEY `AppID` (`AppID`,`Key`), ADD KEY `Key` (`Key`);

ALTER TABLE `AppsTypes`
 ADD PRIMARY KEY (`AppType`), ADD UNIQUE KEY `Name` (`Name`);

ALTER TABLE `Changelists`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `id` (`ChangeID`);

ALTER TABLE `ChangelistsApps`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `ChangeID` (`ChangeID`,`AppID`);

ALTER TABLE `ChangelistsSubs`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `ChangeID` (`ChangeID`,`SubID`);

ALTER TABLE `Depots`
 ADD UNIQUE KEY `DepotID` (`DepotID`);

ALTER TABLE `DepotsFiles`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `File` (`DepotID`,`File`), ADD KEY `DepotID` (`DepotID`);

ALTER TABLE `DepotsHistory`
 ADD PRIMARY KEY (`ID`), ADD KEY `DepotID` (`DepotID`);

ALTER TABLE `DepotsKeys`
 ADD PRIMARY KEY (`DepotID`);

ALTER TABLE `GC`
 ADD UNIQUE KEY `AppID` (`AppID`);

ALTER TABLE `ImportantApps`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `AppID` (`AppID`,`Channel`);

ALTER TABLE `ImportantSubs`
 ADD UNIQUE KEY `AppID` (`SubID`);

ALTER TABLE `KeyNames`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `Name` (`Name`), ADD KEY `Type` (`Type`);

ALTER TABLE `KeyNamesSubs`
 ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `Name` (`Name`), ADD KEY `Type` (`Type`);

ALTER TABLE `PICSTokens`
 ADD PRIMARY KEY (`AppID`);

ALTER TABLE `RSS`
 ADD PRIMARY KEY (`ID`), ADD KEY `Link` (`Link`(255));

ALTER TABLE `StoreUpdateQueue`
 ADD UNIQUE KEY `ID` (`ID`,`Type`);

ALTER TABLE `Subs`
 ADD UNIQUE KEY `SubID` (`SubID`), ADD KEY `LastUpdated` (`LastUpdated`), ADD FULLTEXT KEY `Name` (`Name`,`StoreName`,`LastKnownName`);

ALTER TABLE `SubsApps`
 ADD UNIQUE KEY `Unique` (`SubID`,`AppID`), ADD KEY `AppID` (`AppID`), ADD KEY `SubID` (`SubID`);

ALTER TABLE `SubsHistory`
 ADD PRIMARY KEY (`ID`), ADD KEY `SubID` (`SubID`);

ALTER TABLE `SubsInfo`
 ADD UNIQUE KEY `SubID` (`SubID`,`Key`), ADD KEY `Key` (`Key`);


ALTER TABLE `AppsHistory`
MODIFY `ID` int(9) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `AppsTypes`
MODIFY `AppType` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
ALTER TABLE `Changelists`
MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `ChangelistsApps`
MODIFY `ID` int(11) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `ChangelistsSubs`
MODIFY `ID` int(11) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `DepotsFiles`
MODIFY `ID` int(9) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `DepotsHistory`
MODIFY `ID` int(9) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `ImportantApps`
MODIFY `ID` int(4) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `KeyNames`
MODIFY `ID` smallint(4) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `KeyNamesSubs`
MODIFY `ID` smallint(4) unsigned NOT NULL AUTO_INCREMENT;
ALTER TABLE `RSS`
MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE `SubsHistory`
MODIFY `ID` int(9) unsigned NOT NULL AUTO_INCREMENT;
