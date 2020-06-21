using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
	private static GameManager instance;
	public static GameManager Instance
	{
		get
		{
			if (instance == null)
				instance = FindObjectOfType<GameManager>();

			return instance;
		}
	}

	[SerializeField] PlayerStart playerStart;
	[SerializeField] Text distanceText;
	[SerializeField] Text highScoreText;
	[SerializeField] Transform winPanel;
	[SerializeField] AudioSource bgm;
	[SerializeField] AudioSource win;

	private void Awake()
	{
		highScoreText.text = "Best: " + PlayerPrefs.GetFloat("HIGH_SCORE", 0f).ToString("0.00") + "m";
	}


	public void UpdateDistance(float newDistance)
	{
		if (newDistance > GetHighScore())
			SetHighScore(newDistance);

		distanceText.text = "Distance: " + newDistance.ToString("0.00") + "m";
	}

	public void OnPlayerKilled()
	{
		playerStart.SpawnPlayer();
		bgm.Play();
		win.Stop();
		winPanel.gameObject.SetActive(false);
	}

	public void OnWin()
	{
		winPanel.gameObject.SetActive(true);
		bgm.Stop();
		win.Play();
		Invoke(nameof(OnPlayerKilled), 4f);
	}

	public float GetHighScore()
	{
		return PlayerPrefs.GetFloat("HIGH_SCORE", 0f);
	}

	public void SetHighScore(float score)
	{
		PlayerPrefs.SetFloat("HIGH_SCORE", score);
		highScoreText.text = "Best: " + score.ToString("0.00") + "m";
	}
}
