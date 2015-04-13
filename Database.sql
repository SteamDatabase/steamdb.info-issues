-- This is a partical database structure dump used by SteamDB
-- This structure is not final and can change at any time

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Apps` (
  `AppID` int(7) unsigned NOT NULL,
  `AppType` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown App',
  `StoreName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastKnownName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastDepotUpdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  UNIQUE KEY `AppID` (`AppID`),
  KEY `LastUpdated` (`LastUpdated`),
  KEY `AppType` (`AppType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `AppsHistory` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('created_app','deleted_app','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) unsigned NOT NULL DEFAULT '0',
  `OldValue` mediumtext COLLATE utf8_bin NOT NULL,
  `NewValue` mediumtext COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `AppID` (`AppID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `AppsInfo` (
  `AppID` int(7) unsigned NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `Value` mediumtext COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `AppsTypes` (
  `AppType` tinyint(2) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varbinary(15) NOT NULL,
  `DisplayName` varchar(30) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`AppType`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=17 ;

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

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Changelists` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) unsigned NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `id` (`ChangeID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ChangelistsApps` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) unsigned NOT NULL,
  `AppID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`AppID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ChangelistsSubs` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(11) unsigned NOT NULL,
  `SubID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ChangeID` (`ChangeID`,`SubID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Depots` (
  `DepotID` int(7) unsigned NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown Depot',
  `BuildID` int(7) unsigned NOT NULL DEFAULT '0',
  `ManifestID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Displayed on the website, used for history',
  `LastManifestID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Only updated after file list was successfully updated',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `DepotsFiles` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `DepotID` int(7) unsigned NOT NULL,
  `File` varchar(255) COLLATE utf8_bin NOT NULL,
  `Hash` char(40) COLLATE utf8_bin NOT NULL DEFAULT '0000000000000000000000000000000000000000',
  `Size` bigint(20) unsigned NOT NULL,
  `Flags` int(5) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `File` (`DepotID`,`File`),
  KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `DepotsHistory` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) unsigned NOT NULL,
  `DepotID` int(7) unsigned NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('added','removed','modified','modified_flags','manifest_change','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `File` varchar(300) COLLATE utf8_bin NOT NULL,
  `OldValue` bigint(20) unsigned NOT NULL,
  `NewValue` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `DepotID` (`DepotID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `GC` (
  `AppID` int(7) unsigned NOT NULL,
  `Status` varchar(80) COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `AppID` (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ImportantApps` (
  `ID` int(4) unsigned NOT NULL AUTO_INCREMENT,
  `AppID` int(7) unsigned NOT NULL,
  `Channel` varchar(50) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `AppID` (`AppID`,`Channel`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `ImportantSubs` (
  `SubID` int(7) unsigned NOT NULL,
  UNIQUE KEY `AppID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `KeyNames` (
  `ID` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(120) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `KeyNamesSubs` (
  `ID` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `Type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `Name` varchar(90) COLLATE utf8_bin NOT NULL,
  `DisplayName` varchar(90) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `Type` (`Type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `RSS` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) COLLATE utf8_bin NOT NULL,
  `Link` varchar(300) COLLATE utf8_bin NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `Link` (`Link`(255))
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `StoreUpdateQueue` (
  `ID` int(7) unsigned NOT NULL,
  `Type` enum('app','sub') COLLATE utf8_bin NOT NULL,
  `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `ID` (`ID`,`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `Subs` (
  `SubID` int(7) unsigned NOT NULL,
  `Name` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT 'SteamDB Unknown Package',
  `StoreName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastKnownName` varchar(150) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `LastUpdated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `SubID` (`SubID`),
  KEY `LastUpdated` (`LastUpdated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SubsApps` (
  `SubID` int(7) unsigned NOT NULL,
  `AppID` int(7) unsigned NOT NULL,
  `Type` enum('app','depot') COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `Unique` (`SubID`,`AppID`),
  KEY `AppID` (`AppID`),
  KEY `SubID` (`SubID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SubsHistory` (
  `ID` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `ChangeID` int(9) unsigned NOT NULL,
  `SubID` int(7) unsigned NOT NULL,
  `Time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Action` enum('created_sub','deleted_sub','created_key','removed_key','modified_key','created_info','modified_info','removed_info','modified_price','added_to_sub','removed_from_sub') COLLATE utf8_bin NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `OldValue` text COLLATE utf8_bin NOT NULL,
  `NewValue` text COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `SubID` (`SubID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `SubsInfo` (
  `SubID` int(7) unsigned NOT NULL,
  `Key` smallint(4) unsigned NOT NULL,
  `Value` text COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `SubID` (`SubID`,`Key`),
  KEY `Key` (`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
