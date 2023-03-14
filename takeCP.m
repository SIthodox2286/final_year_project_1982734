function [points_season,points_trend] = takeCP(beastmodel,probThreshold)
    %% Introduction

    %% Main
    points_season = beastmodel.season.cp;
    points_season_prob = beastmodel.season.cpPr;
    points_season_prob = points_season_prob(~isnan(points_season));
    points_season = points_season(~isnan(points_season));
    points_season = [points_season,points_season_prob];
    points_season = sortrows(points_season);
    points_season = points_season(find(points_season(:,2)>=probThreshold));

    points_trend = beastmodel.trend.cp;
    points_trend_prob = beastmodel.trend.cpPr;
    points_trend_prob = points_trend_prob(~isnan(points_trend));
    points_trend = points_trend(~isnan(points_trend));
    points_trend = [points_trend,points_trend_prob];
    points_trend = sortrows(points_trend);
    points_trend = points_trend(find(points_trend(:,2)>=probThreshold));

end

